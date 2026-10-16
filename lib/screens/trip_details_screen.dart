import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../services/map_service.dart';
import '../widgets/place_card.dart';
import 'map.dart';
import 'place_details_screen.dart';

class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.name),
        actions: [
          if (trip.places.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.map_outlined),
              tooltip: 'Դիտել ճանապարհորդությունը քարտեզում',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(selectedPlace: trip.places.first),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ամսաթվեր՝ ${trip.startDate.toLocal().toString().split(' ')[0]} - ${trip.endDate.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            if (trip.places.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MapScreen(selectedPlace: trip.places.first),
                    ),
                  ),
                  icon: const Icon(Icons.push_pin),
                  label: const Text('Դիտել բոլոր ուղղությունները քարտեզում'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => MapService.openDirections(
                    latitude: trip.places.first.latitude,
                    longitude: trip.places.first.longitude,
                  ),
                  icon: const Icon(Icons.navigation, size: 18),
                  label: const Text(
                    'Ուղղություններ առաջին կետ OpenStreetMap-ում',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Ուղղություններ այս ճանապարհորդությունում',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (trip.places.isEmpty)
              const Text('Ոչ մի վայր չի ավելացվել այս ճանապարհորդությանը.')
            else
              ...trip.places.map(
                (place) => PlaceCard(
                  place: place,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(place: place),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
