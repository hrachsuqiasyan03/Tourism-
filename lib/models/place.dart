export 'city.dart';

class Place {
  final int id;
  final String name;
  final String type;
  final String description;
  final String imagePath;
  final double latitude;
  final double longitude;
  final double rating;
  final String city;

  Place({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.city = '',
  });
}