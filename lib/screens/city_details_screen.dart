import 'package:flutter/material.dart';

import '../data/mock_places.dart';
import '../models/place.dart';
import '../widgets/place_card.dart';
import 'map.dart';
import 'place_details_screen.dart';

class CityDetailsScreen extends StatelessWidget {
  final City city;

  const CityDetailsScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final cityPlaces = places
        .where((place) => place.city == city.name)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(city.name)),
      body: CustomScrollView(
        primary: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: city.imagePath.startsWith('http')
                ? Image.network(
                    city.imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _imageError(),
                  )
                : Image.asset(
                    city.imagePath,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _imageError(),
                  ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                city.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Բնակավայրեր',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapScreen(
                          selectedCity: city.name,
                          selectedRegion: city.region,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Քարտեզ'),
                  ),
                ],
              ),
            ),
          ),
          if (cityPlaces.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Ոչ մի վայր չի գտնվել.', style: TextStyle(fontSize: 18)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final place = cityPlaces[index];
                  return PlaceCard(
                    place: place,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsScreen(place: place),
                      ),
                    ),
                  );
                }, childCount: cityPlaces.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _imageError() => Container(
    height: 180,
    color: Colors.grey.shade300,
    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
  );
}
