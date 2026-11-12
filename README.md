# first

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## OpenStreetMap

The in-app map uses OpenStreetMap tiles through `flutter_map`; it does not need a Google Maps API key. An internet connection is required for map tiles. The map displays OpenStreetMap contributor attribution and filters markers using the existing city and place data.

Run `flutter pub get`, then `flutter run`. Location is requested only when **My Location** is tapped. iOS uses the location prompt in `Info.plist`; Android uses the standard foreground location permission.

## Trip planner

The Trips tab reuses the existing Armenian place catalog. Trips support date and preference setup, per-day destination selection and reordering, visit times and notes, expense tracking in AMD, and trip sharing by copying a text itinerary. The Trips screens do not include map or route functionality; the existing standalone map remains available in the main navigation.

This project currently has no trip backend API. Trip data is kept in memory for the current app session and is **not permanently saved**.
