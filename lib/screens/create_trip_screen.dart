import 'package:flutter/material.dart';
import '../data/mock_places.dart';
import '../models/place.dart';
import '../models/trip.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _nameController = TextEditingController();
  final DateTime _startDate = DateTime.now();
  final DateTime _endDate = DateTime.now().add(const Duration(days: 3));
  final List<Place> _selectedPlaces = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ստեղծել նոր ճանապարհորդություն')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ճանապարհորդության անունը',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ընտրել ուղղություններ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...places.map((place) {
              final isSelected = _selectedPlaces.contains(place);
              return CheckboxListTile(
                title: Text(place.name),
                subtitle: Text(place.city),
                value: isSelected,
                onChanged: (bool? val) {
                  setState(() {
                    if (val == true) {
                      _selectedPlaces.add(place);
                    } else {
                      _selectedPlaces.remove(place);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Խնդրում ենք մուտքագրել ճանապարհորդության անունը')),
                    );
                    return;
                  }
                  final newTrip = Trip(
                    id: DateTime.now().millisecondsSinceEpoch,
                    name: _nameController.text.trim(),
                    startDate: _startDate,
                    endDate: _endDate,
                    places: List.from(_selectedPlaces),
                  );
                  Navigator.pop(context, newTrip);
                },
                child: const Text('Պահպանել ճանապարհորդությունը'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
