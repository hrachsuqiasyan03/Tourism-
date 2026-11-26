import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_locale.dart';
import '../models/trip.dart';
import '../services/routing_service.dart';

class TripMapScreen extends StatefulWidget {
  const TripMapScreen({super.key, required this.trip});

  final Trip trip;

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  final MapController _mapController = MapController();
  int? _selectedDay;
  TripPlace? _selectedVisit;
  RouteResult? _route;
  String? _routeError;
  bool _loadingRoute = false;
  bool _mapReady = false;
  bool _showTrajectory = true;

  List<TripPlace> get _visibleVisits => [
    for (final day in widget.trip.days)
      if (_selectedDay == null || day.dayNumber == _selectedDay)
        ...day.places.where(_hasCoordinates),
  ];

  bool _hasCoordinates(TripPlace visit) {
    final latitude = visit.place.latitude;
    final longitude = visit.place.longitude;
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  LatLng _point(TripPlace visit) =>
      LatLng(visit.place.latitude, visit.place.longitude);

  @override
  void initState() {
    super.initState();
    if (widget.trip.days.isNotEmpty) {
      _selectedDay = widget.trip.days.first.dayNumber;
    }
    _loadRoute();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadRoute() async {
    final visits = _visibleVisits;
    if (visits.length < 2) {
      setState(() {
        _route = null;
        _routeError = null;
        _loadingRoute = false;
      });
      return;
    }

    setState(() {
      _loadingRoute = true;
      _routeError = null;
    });
    try {
      var totalDistance = 0.0;
      var totalDuration = 0.0;
      final geometry = <LatLng>[];

      for (var index = 0; index < visits.length - 1; index++) {
        final segment = await RoutingService.getArmeniaDrivingRoute(
          _point(visits[index]),
          _point(visits[index + 1]),
        );
        totalDistance += segment.distanceMeters;
        totalDuration += segment.durationSeconds;

        if (geometry.isEmpty) {
          geometry.addAll(segment.geometry);
        } else if (segment.geometry.isNotEmpty) {
          if (geometry.last == segment.geometry.first) {
            geometry.addAll(segment.geometry.skip(1));
          } else {
            geometry.addAll(segment.geometry);
          }
        }
      }

      final result = RouteResult(
        geometry: geometry,
        distanceMeters: totalDistance,
        durationSeconds: totalDuration,
      );
      if (!mounted) return;
      setState(() => _route = result);
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _routeError = error.toString());
    } finally {
      if (mounted) setState(() => _loadingRoute = false);
    }
  }

  void _selectDay(int? dayNumber) {
    setState(() {
      _selectedDay = dayNumber;
      _selectedVisit = null;
      _route = null;
    });
    _loadRoute();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitVisibleVisits());
  }

  void _onMapReady() {
    _mapReady = true;
    _fitVisibleVisits();
  }

  void _fitVisibleVisits() {
    if (!_mapReady) return;
    final points = _visibleVisits.map(_point).toList();
    if (points.isEmpty) return;
    if (points.length == 1) {
      _mapController.move(points.single, 13);
      return;
    }
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds.fromPoints(points),
        padding: const EdgeInsets.fromLTRB(48, 150, 48, 150),
        maxZoom: 13,
      ),
    );
  }

  List<Marker> _markers() {
    var stopNumber = 0;
    return [
      for (final day in widget.trip.days)
        if (_selectedDay == null || day.dayNumber == _selectedDay)
          for (final visit in day.places.where(_hasCoordinates))
            Marker(
              point: _point(visit),
              width: 42,
              height: 48,
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedVisit = visit);
                  _mapController.move(_point(visit), 14);
                },
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedVisit == visit
                            ? const Color(0xFFD99A62)
                            : const Color(0xFF17453D),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        '${++stopNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF17453D),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.trip.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    body: Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(40.1792, 44.4991),
            initialZoom: 7.2,
            onMapReady: _onMapReady,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.first',
              maxZoom: 19,
            ),
            if (_showTrajectory && _route != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _route!.geometry,
                    strokeWidth: 5,
                    color: const Color(0xFF17453D),
                  ),
                ],
              ),
            MarkerLayer(markers: _markers()),
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
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.route_outlined, color: Color(0xFF17453D)),
                  const SizedBox(width: 8),
                  Expanded(child: _routeSummary()),
                  IconButton(
                    tooltip: _showTrajectory
                        ? 'Թաքցնել ուղու հետքը'
                        : 'Ցույց տալ ուղու հետքը',
                    onPressed: () =>
                        setState(() => _showTrajectory = !_showTrajectory),
                    icon: Icon(
                      _showTrajectory
                          ? Icons.timeline
                          : Icons.timeline_outlined,
                    ),
                  ),
                  if (_routeError != null)
                    IconButton(
                      tooltip: 'Կրկին փորձել',
                      onPressed: _loadRoute,
                      icon: const Icon(Icons.refresh),
                    ),
                  IconButton(
                    tooltip: 'Կենտրոնացնել ուղղությունները',
                    onPressed: _fitVisibleVisits,
                    icon: const Icon(Icons.center_focus_strong),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 76,
          left: 12,
          right: 12,
          child: SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Բոլոր օրերը'),
                    selected: _selectedDay == null,
                    onSelected: (_) => _selectDay(null),
                  ),
                ),
                for (final day in widget.trip.days)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        '${AppLocale.ordinalNumber(day.dayNumber)} օր',
                      ),
                      selected: _selectedDay == day.dayNumber,
                      onSelected: (_) => _selectDay(day.dayNumber),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (_selectedVisit case final visit?)
          Positioned(
            left: 12,
            right: 12,
            bottom: 24,
            child: Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    visit.place.imagePath,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(
                      width: 54,
                      height: 54,
                      child: Icon(Icons.place),
                    ),
                  ),
                ),
                title: Text(visit.place.name),
                subtitle: Text(
                  '${TimeOfDay.fromDateTime(visit.arrivalTime).format(context)} · ${visit.place.type}',
                ),
                trailing: IconButton(
                  tooltip: 'Փակել',
                  onPressed: () => setState(() => _selectedVisit = null),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
        if (_visibleVisits.isEmpty)
          Positioned(
            left: 20,
            right: 20,
            top: 140,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _selectedDay == null
                      ? 'Այս ուղևորության համար քարտեզային կոորդինատներով վայրեր չկան։'
                      : 'Այս օրվա համար քարտեզային կոորդինատներով վայրեր չկան։',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    ),
  );

  Widget _routeSummary() {
    if (_loadingRoute) {
      return const Text('Հաշվարկվում է երթուղին…');
    }
    if (_routeError != null) {
      return Text(
        'Ճանապարհային երթուղին հասանելի չէ։',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }
    if (_route != null) {
      final distance = (_route!.distanceMeters / 1000).toStringAsFixed(1);
      final duration = (_route!.durationSeconds / 60).round();
      return Text('$distance կմ · մեքենայով մոտ $duration րոպե');
    }
    if (_visibleVisits.length == 1) {
      return const Text('Այս օրվա մեկ ուղղություն');
    }
    return Text('${_visibleVisits.length} ուղղություն · ընտրեք կանգառը');
  }
}
