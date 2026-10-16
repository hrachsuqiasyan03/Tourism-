import 'package:flutter/material.dart';

import '../data/mock_places.dart';
import '../models/region.dart';
import '../widgets/city_card.dart';
import 'city_details_screen.dart';
import 'map.dart';

class RegionDetailsScreen extends StatelessWidget {
  final Region region;

  const RegionDetailsScreen({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    final regionCities = cities
        .where((city) => city.region.toLowerCase() == region.name.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(region.name),
        actions: [
          IconButton(
            tooltip: 'Դիտել մարզը քարտեզում',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapScreen(selectedRegion: region.name),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        primary: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: region.imagePath.startsWith('http')
                ? Image.network(
                    region.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Image.asset(
                    region.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    region.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Մեծագույն քաղաքը՝ ${region.biggestCity}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Քաղաքներ',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (regionCities.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Ոչ մի քաղաք չի գտնվել.', style: TextStyle(fontSize: 18)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final city = regionCities[index];
                  return CityCard(
                    city: city,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CityDetailsScreen(city: city),
                      ),
                    ),
                  );
                }, childCount: regionCities.length),
              ),
            ),
        ],
      ),
    );
  }
}
