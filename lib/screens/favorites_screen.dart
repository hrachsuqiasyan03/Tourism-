import 'package:flutter/material.dart';

import '../services/favorites_service.dart';
import '../widgets/place_card.dart';
import 'place_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Ընտրանի')),

      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Դեռևս չկան ընտրյալ ուղղություններ.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: favorites.length,

              itemBuilder: (context, index) {
                final place = favorites[index];

                return PlaceCard(
                  place: place,

                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(place: place),
                      ),
                    );

                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}
