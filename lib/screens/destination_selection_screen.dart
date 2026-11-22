import 'package:flutter/material.dart';

import '../data/app_locale.dart';
import '../data/mock_places.dart' as mock;
import '../models/place.dart';
import '../models/trip.dart';
import '../services/trip_repository.dart';
import 'place_details_screen.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({super.key, required this.trip});

  final Trip trip;

  @override
  State<DestinationSelectionScreen> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  String _query = '';
  String _region = 'Բոլոր մարզերը';
  String _category = 'Բոլոր տեսակները';
  int _dayIndex = 0;

  List<String> get _regions => [
    'Բոլոր մարզերը',
    ...mock.cities.map((city) => city.region).toSet().toList()..sort(),
  ];

  List<String> get _categories => [
    'Բոլոր տեսակները',
    ...mock.places
        .map((place) => place.type)
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList()
      ..sort(),
  ];

  List<Place> get _availablePlaces {
    final query = _query.trim().toLowerCase();
    return mock.places.where((place) {
      final city = mock.cities
          .where(
            (item) => item.places.any((candidate) => candidate.id == place.id),
          )
          .firstOrNull;
      final regionMatches =
          _region == 'Բոլոր մարզերը' || city?.region == _region;
      final categoryMatches =
          _category == 'Բոլոր տեսակները' ||
          place.type.toLowerCase() == _category.toLowerCase();
      final queryMatches =
          query.isEmpty ||
          place.name.toLowerCase().contains(query) ||
          place.description.toLowerCase().contains(query) ||
          (city?.name.toLowerCase().contains(query) ?? false);
      return regionMatches && categoryMatches && queryMatches;
    }).toList();
  }

  void _add(Place place) {
    if (widget.trip.places.any((item) => item.id == place.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Այս վայրը արդեն ավելացված է։')),
      );
    } else {
      final day = widget.trip.days[_dayIndex];
      final lastVisit = day.places.isEmpty ? null : day.places.last;
      final arrival = lastVisit == null
          ? day.date.add(const Duration(hours: 9))
          : lastVisit.arrivalTime.add(
              Duration(minutes: lastVisit.visitMinutes + 30),
            );
      day.places.add(TripPlace(place: place, arrivalTime: arrival));
      TripRepository.update(widget.trip);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${place.name}՝ ավելացված է ${AppLocale.ordinalNumber(day.dayNumber)} օրվան',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ընտրել ուղղություններ')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Որոնել տեսարժան վայրեր',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _region,
                      decoration: const InputDecoration(labelText: 'Մարզ'),
                      items: _regions
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _region = value ?? _regions.first),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Տեսակ'),
                      items: _categories
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(
                        () => _category = value ?? 'Բոլոր տեսակները',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                initialValue: _dayIndex,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.today_outlined),
                  labelText: 'Ավելացնել այս օրվան',
                ),
                items: [
                  for (var index = 0; index < widget.trip.days.length; index++)
                    DropdownMenuItem(
                      value: index,
                      child: Text(
                        '${AppLocale.ordinalNumber(widget.trip.days[index].dayNumber)} օր · ${_formatDate(widget.trip.days[index].date)}',
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _dayIndex = value ?? 0),
              ),
            ],
          ),
        ),
        Expanded(
          child: _availablePlaces.isEmpty
              ? const Center(child: Text('Համապատասխան ուղղություններ չկան։'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: _availablePlaces.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final place = _availablePlaces[index];
                    final selected = widget.trip.places.any(
                      (item) => item.id == place.id,
                    );
                    final city = mock.cities
                        .where(
                          (item) => item.places.any(
                            (candidate) => candidate.id == place.id,
                          ),
                        )
                        .firstOrNull;
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PlaceDetailsScreen(place: place),
                              ),
                            ),
                            child: SizedBox(
                              height: 145,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    place.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: const Color(0xFFE5E9E5),
                                      child: const Icon(
                                        Icons.landscape,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 75,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Color(0xCC000000),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 14,
                                    right: 14,
                                    bottom: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          '${city?.name ?? place.city} · ${city?.region ?? ''}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        place.type,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        '${place.latitude.toStringAsFixed(3)}, ${place.longitude.toStringAsFixed(3)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FilledButton.tonalIcon(
                                    onPressed: () => _add(place),
                                    icon: Icon(
                                      selected
                                          ? Icons.check
                                          : Icons.add_location_alt_outlined,
                                      size: 18,
                                    ),
                                    label: Text(
                                      selected ? 'Ավելացված է' : 'Ավելացնել',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );

  String _formatDate(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}';
}
