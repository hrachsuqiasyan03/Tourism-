import 'package:flutter/material.dart';

import '../services/map_service.dart';
import '../models/place.dart';
import '../services/favorites_service.dart';
import '../services/selected_places_service.dart';
import 'map.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    final isFavorite = FavoritesService.isFavorite(place);
    final isPinned = SelectedPlacesService.isSelected(place);

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Դիտել քարտեզում',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(selectedPlace: place),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            place.imagePath.startsWith('http')
                ? Image.network(
                    place.imagePath,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Image.asset(
                    place.imagePath,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    place.name,

                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '📍 ${place.city}',

                    style: const TextStyle(fontSize: 17),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '⭐ ${place.rating}',

                    style: const TextStyle(fontSize: 17),
                  ),

                  const SizedBox(height: 20),

                  Text(place.description, style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          FavoritesService.toggleFavorite(place);
                        });
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(
                        isFavorite
                            ? 'Հեռացնել ընտրանիից'
                            : 'Ավելացնել ընտրանի',
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPinned
                            ? Colors.grey.shade300
                            : Colors.red.shade600,
                        foregroundColor: isPinned
                            ? Colors.black87
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          SelectedPlacesService.togglePlace(place);
                        });
                      },
                      icon: Icon(
                        Icons.push_pin,
                        color: isPinned ? Colors.red : Colors.white,
                      ),
                      label: Text(
                        isPinned
                            ? 'Հեռացնել քարտեզից'
                            : 'Ցանկանում եմ գնալ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapScreen(selectedPlace: place),
                              ),
                            );
                          },
                          icon: const Icon(Icons.explore),
                          label: const Text('Դիտել քարտեզում'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A73E8),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => MapService.openOpenStreetMap(
                            latitude: place.latitude,
                            longitude: place.longitude,
                          ),
                          icon: const Icon(Icons.map, size: 15),
                          label: const Text('OpenStreetMap'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => MapService.openDirections(
                        latitude: place.latitude,
                        longitude: place.longitude,
                      ),
                      icon: const Icon(
                        Icons.directions,
                        color: Color(0xFF1A73E8),
                      ),
                      label: const Text(
                        'Ստանալ ուղղություններ OpenStreetMap-ում',
                        style: TextStyle(color: Color(0xFF1A73E8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
