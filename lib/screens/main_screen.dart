import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'map.dart';
import 'my_trips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),

    SearchScreen(),

    MapScreen(),

    MyTripsScreen(),

    FavoritesScreen(),

    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Գլխավոր',
          ),

          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Որոնում',
          ),

          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Քարտեզ',
          ),

          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'Ուղևորություններ',
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Ընտրանի',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Պրոֆիլ',
          ),
        ],
      ),
    );
  }
}
