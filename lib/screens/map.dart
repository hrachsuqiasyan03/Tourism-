import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/mock_places.dart';
import '../data/mock_regions.dart';
import '../models/place.dart';
import '../services/favorites_service.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';
import '../services/selected_places_service.dart';
import 'place_details_screen.dart';

class MapScreen extends StatefulWidget {
  final Place? selectedPlace;
  final String? selectedCity;
  final String? selectedRegion;

  const MapScreen({
    super.key,
    this.selectedPlace,
    this.selectedCity,
    this.selectedRegion,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _armeniaCenter = LatLng(40.1792, 44.4991);

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  late Place? _selectedPlace;
  late String _region;
  late String _city;
  String _query = '';
  bool _mapReady = false;
  bool _loadingLocation = false;
  LatLng? _userLocation;

  List<_PlaceEntry> get _allEntries => [
    for (final city in cities)
      for (final sourcePlace in city.places)
        _PlaceEntry(
          place: places.firstWhere(
            (place) => place.id == sourcePlace.id,
            orElse: () => sourcePlace,
          ),
          city: city,
        ),
  ];

  List<_PlaceEntry> get _filteredEntries => _allEntries.where((entry) {
    final regionMatches =
        _region == 'Բոլոր մարզերը' || entry.city.region == _region;
    final cityMatches = _city == 'Բոլոր քաղաքները' || entry.city.name == _city;
    final queryMatches =
        _query.isEmpty ||
        entry.place.name.toLowerCase().contains(_query.toLowerCase()) ||
        entry.city.name.toLowerCase().contains(_query.toLowerCase());
    return regionMatches && cityMatches && queryMatches && _valid(entry.place);
  }).toList();

  bool get _locationFilterSelected =>
      _region != 'Բոլոր մարզերը' || _city != 'Բոլոր քաղաքները';

  List<_PlaceEntry> get _markerEntries {
    if (_locationFilterSelected) return _filteredEntries;
    if (_selectedPlace == null) return const [];
    return _allEntries
        .where((entry) => entry.place.id == _selectedPlace!.id)
        .toList();
  }

  List<String> get _regions => [
    'Բոլոր մարզերը',
    ...cities.map((city) => city.region).toSet().toList()..sort(),
  ];

  List<String> get _cityOptions => [
    'Բոլոր քաղաքները',
    ...cities
        .where((city) => _region == 'Բոլոր մարզերը' || city.region == _region)
        .map((city) => city.name)
        .toList()
      ..sort(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.selectedPlace;
    _region = widget.selectedRegion ?? 'Բոլոր մարզերը';
    _city = widget.selectedCity ?? 'Բոլոր քաղաքները';
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool _valid(Place place) =>
      place.latitude.isFinite &&
      place.longitude.isFinite &&
      place.latitude >= -90 &&
      place.latitude <= 90 &&
      place.longitude >= -180 &&
      place.longitude <= 180;

  LatLng _point(Place place) => LatLng(place.latitude, place.longitude);

  void _onMapReady() {
    _mapReady = true;
    if (_selectedPlace != null && _valid(_selectedPlace!)) {
      _moveToPlace(_selectedPlace!, zoom: 14.5);
    } else if (widget.selectedCity != null || widget.selectedRegion != null) {
      _fitPlaces();
    }
  }

  void _moveToPlace(Place place, {double zoom = 14}) {
    if (!_valid(place)) {
      _showMessage('This place does not have valid map coordinates.');
      return;
    }
    setState(() => _selectedPlace = place);
    if (_mapReady) _mapController.move(_point(place), zoom);
  }

  void _fitPlaces() {
    if (!_locationFilterSelected && _selectedPlace == null) return;
    final visibleCities = cities.where(
      (city) => _locationFilterSelected &&
          (_region == 'Բոլոր մարզերը' || city.region == _region) &&
          (_city == 'Բոլոր քաղաքները' || city.name == _city),
    );
    final visibleRegions = regions.where(
      (region) =>
          _region != 'Բոլոր մարզերը' && region.name == _region,
    );
    final points = <LatLng>[
      ...(_locationFilterSelected
              ? _filteredEntries
              : _allEntries.where(
                  (entry) => entry.place.id == _selectedPlace?.id,
                ))
          .map((entry) => _point(entry.place)),
      ...visibleCities.map((city) => LatLng(city.latitude, city.longitude)),
      ...visibleRegions.map(
        (region) => LatLng(region.latitude, region.longitude),
      ),
    ];
    if (points.isEmpty) return;
    if (!_mapReady) return;
    if (points.length == 1) {
      _mapController.move(points.single, 13);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.fromLTRB(48, 150, 72, 100),
        maxZoom: 12,
      ),
    );
    setState(() => _selectedPlace = null);
  }

  void _selectRegion(String? value) {
    if (value == null) return;
    setState(() {
      _region = value;
      _city = 'Բոլոր քաղաքները';
      _query = '';
      _searchController.clear();
      _selectedPlace = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitPlaces());
  }

  void _selectCity(String? value) {
    if (value == null) return;
    setState(() {
      _city = value;
      _query = '';
      _searchController.clear();
      _selectedPlace = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitPlaces());
  }

  void _search(String value) {
    final query = value.trim();
    setState(() => _query = query);
    if (query.isEmpty) return;

    final match = _allEntries.where((entry) {
      return entry.place.name.toLowerCase().contains(query.toLowerCase());
    }).firstOrNull;
    if (match == null) {
      _showMessage('Ոչ մի տեսարժան վայր չի գտնվել “$query”-ի համար.');
      return;
    }

    setState(() {
      _region = 'Բոլոր մարզերը';
      _city = 'Բոլոր քաղաքները';
    });
    _moveToPlace(match.place, zoom: 15);
  }

  Future<void> _showMyLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final position = await LocationService.getCurrentPosition();
      if (!mounted) return;
      final point = LatLng(position.latitude, position.longitude);
      setState(() => _userLocation = point);
      if (_mapReady) _mapController.move(point, 14);
    } on LocationServiceDisabledException {
      _showMessage('Միացրեք դիրքի ծառայությունները Իմ դիրքը օգտագործելու համար.');
    } on LocationPermissionDeniedException {
      _showMessage(
        'Դիրքի թույլտվությունը մերժված է. սեղմեք Իմ դիրքը կրկին փորձելու համար.',
      );
    } on LocationPermissionPermanentlyDeniedException {
      _showMessage('Միացրեք դիրքի թույլտվությունը կարգավորումներում.');
    } catch (_) {
      _showMessage(
        'Չհաջողվեց ստանալ ձեր դիրքը. ստուգեք կարգավորումները և կրկին փորձեք.',
      );
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _googleLocationPin({Color color = const Color(0xFFEA4335)}) =>
      SizedBox(
        width: 32,
        height: 36,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(Icons.location_on, color: color, size: 36),
            Positioned(
              top: 8,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  Set<Marker> _buildMarkers() => {
    for (final city in cities.where(
      (city) =>
          _locationFilterSelected &&
          (_region == 'Բոլոր մարզերը' || city.region == _region) &&
          (_city == 'Բոլոր քաղաքները' || city.name == _city),
    ))
      Marker(
        point: LatLng(city.latitude, city.longitude),
        width: 32,
        height: 36,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _region = city.region;
              _city = city.name;
              _query = '';
              _searchController.clear();
              _selectedPlace = null;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) => _fitPlaces());
          },
          child: _googleLocationPin(),
        ),
      ),
    for (final region in regions.where(
      (region) => _region != 'Բոլոր մարզերը' && region.name == _region,
    ))
      Marker(
        point: LatLng(region.latitude, region.longitude),
        width: 32,
        height: 36,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _region = region.name;
              _city = 'Բոլոր քաղաքները';
              _query = '';
              _searchController.clear();
              _selectedPlace = null;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) => _fitPlaces());
          },
          child: _googleLocationPin(),
        ),
      ),
    for (final entry in _markerEntries)
      Marker(
        point: _point(entry.place),
        width: 32,
        height: 36,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _moveToPlace(entry.place, zoom: 14),
          child: _googleLocationPin(
            color: _selectedPlace?.id == entry.place.id
                ? const Color(0xFFC5221F)
                : const Color(0xFFEA4335),
          ),
        ),
      ),
    if (_userLocation case final location?)
      Marker(
        point: location,
        width: 28,
        height: 28,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withValues(alpha: 0.2),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
  };

  Widget _floatingButton(IconData icon, String label, VoidCallback onPressed) =>
      Material(
        color: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: label,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      );

  Widget _buildPlaceCard(_PlaceEntry entry) {
    final place = entry.place;
    final isFavorite = FavoritesService.isFavorite(place);
    final isPinned = SelectedPlacesService.isSelected(place);
    return Card(
      elevation: 8,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    place.imagePath,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 72,
                      height: 72,
                      color: Colors.blueGrey.shade100,
                      child: const Icon(Icons.place, size: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${entry.city.name} · ${entry.city.region}'),
                      Text('★ ${place.rating.toStringAsFixed(1)}'),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite ? 'Հեռացնել ընտրանիից' : 'Ավելացնել ընտրանի',
                  onPressed: () =>
                      setState(() => FavoritesService.toggleFavorite(place)),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  tooltip: 'Փակել վայրի քարտը',
                  onPressed: () => setState(() => _selectedPlace = null),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              place.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Wrap(
              spacing: 4,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailsScreen(place: place),
                    ),
                  ),
                  child: const Text('Դիտել մանրամասներ'),
                ),
                TextButton.icon(
                  onPressed: () => _openDirections(place),
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Ուղղություններ'),
                ),
                TextButton.icon(
                  onPressed: () =>
                      setState(() => SelectedPlacesService.togglePlace(place)),
                  icon: Icon(
                    isPinned ? Icons.push_pin : Icons.add_road,
                    size: 18,
                  ),
                  label: Text(isPinned ? 'Ճանապարհորդությունում' : 'Ավելացնել ճանապարհորդությանը'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDirections(Place place) async {
    final opened = await MapService.openDirections(
      latitude: place.latitude,
      longitude: place.longitude,
    );
    if (!opened) _showMessage('Could not open OpenStreetMap directions.');
  }

  @override
  Widget build(BuildContext context) {
    final selectedEntry = _selectedPlace == null
        ? null
        : _allEntries
              .where((entry) => entry.place.id == _selectedPlace!.id)
              .firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Զննել Հայաստանը'), centerTitle: true),
      body: Stack(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.grab,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedPlace != null && _valid(_selectedPlace!)
                    ? _point(_selectedPlace!)
                    : _armeniaCenter,
                initialZoom: _selectedPlace == null ? 7.2 : 14.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onMapReady: _onMapReady,
                onTap: (_, point) {
                  if (selectedEntry != null) {
                    setState(() => _selectedPlace = null);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.first',
                  maxZoom: 19,
                ),
                MarkerLayer(markers: _buildMarkers().toList()),
                RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://www.openstreetmap.org/copyright'),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Material(
              color: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (value) => setState(() => _query = value.trim()),
                onSubmitted: _search,
                decoration: InputDecoration(
                  hintText: 'Որոնել տեսարժան վայրեր',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Positioned(
            top: 72,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Expanded(
                  child: _filterDropdown(_region, _regions, _selectRegion),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _filterDropdown(_city, _cityOptions, _selectCity),
                ),
              ],
            ),
          ),
          Positioned(
            top: 126,
            right: 12,
            child: Column(
              children: [
                _floatingButton(
                  Icons.add,
                  'Մեծացնել',
                  () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                ),
                const SizedBox(height: 8),
                _floatingButton(
                  Icons.remove,
                  'Փոքրացնել',
                  () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                ),
                const SizedBox(height: 8),
                _floatingButton(
                  Icons.my_location,
                  'Իմ դիրքը',
                  _showMyLocation,
                ),
                const SizedBox(height: 8),
                _floatingButton(Icons.public, 'Ցույց տալ բոլոր վայրերը', _fitPlaces),
                const SizedBox(height: 8),
                _floatingButton(Icons.home, 'Կենտրոնացնել Հայաստանը', () {
                  setState(() {
                    _region = 'Բոլոր մարզերը';
                    _city = 'Բոլոր քաղաքները';
                    _query = '';
                    _selectedPlace = null;
                    _searchController.clear();
                  });
                  if (_mapReady) _mapController.move(_armeniaCenter, 7.2);
                }),
              ],
            ),
          ),
          if (selectedEntry != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 54,
              child: _buildPlaceCard(selectedEntry),
            ),
          if (_filteredEntries.isEmpty)
            Positioned(
              left: 16,
              right: 72,
              bottom: selectedEntry == null ? 24 : null,
              top: selectedEntry == null ? null : 180,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _query.isEmpty
                        ? 'Ոչ մի վայր չի համապատասխանում այս ֆիլտրերին.'
                        : 'Ոչ մի վայր չի գտնվել "$_query".',
                  ),
                ),
              ),
            ),
          if (_loadingLocation)
            const Positioned(
              left: 0,
              right: 0,
              top: 145,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _filterDropdown(
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) => Material(
    color: Colors.white,
    elevation: 4,
    borderRadius: BorderRadius.circular(12),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: options.contains(value) ? value : options.first,
        isExpanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        borderRadius: BorderRadius.circular(12),
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(option, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

class _PlaceEntry {
  final Place place;
  final City city;

  const _PlaceEntry({required this.place, required this.city});
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
