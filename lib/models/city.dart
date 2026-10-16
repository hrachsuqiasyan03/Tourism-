import 'place.dart';

class City {
  final int id;
  final String name;
  final String region;
  final String description;
  final String imagePath;
  final List<Place> places;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    this.region = '',
    required this.description,
    required this.imagePath,
    this.places = const [],
    required this.latitude,
    required this.longitude,
  });
}
