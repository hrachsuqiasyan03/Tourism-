import 'package:flutter/material.dart';

import '../models/trip.dart';
import 'create_trip_screen.dart';
import 'trip_details_screen.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final List<Trip> trips = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Իմ ճանապարհորդությունները')),
      body: trips.isEmpty
          ? const Center(
              child: Text(
                'Դեռևս ճանապարհորդություններ չեն պլանավորված.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      trip.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${trip.startDate.toLocal().toString().split(' ')[0]} - ${trip.endDate.toLocal().toString().split(' ')[0]} • ${trip.places.length} places',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailsScreen(trip: trip),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTrip = await Navigator.push<Trip>(
            context,
            MaterialPageRoute(builder: (context) => const CreateTripScreen()),
          );
          if (newTrip != null) {
            setState(() {
              trips.add(newTrip);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
