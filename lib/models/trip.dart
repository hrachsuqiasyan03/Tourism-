import 'package:first/models/place.dart';

class Trip {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<Place> places;

  Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.places,
  });
}
