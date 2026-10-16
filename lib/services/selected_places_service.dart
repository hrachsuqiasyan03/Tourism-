import 'package:flutter/foundation.dart';
import '../models/place.dart';

/// Service to manage places that the user wants to visit / has pinned on the map.
class SelectedPlacesService {
  static final ValueNotifier<List<Place>> selectedPlacesNotifier =
      ValueNotifier<List<Place>>([]);

  static List<Place> get selectedPlaces =>
      List.unmodifiable(selectedPlacesNotifier.value);

  static bool isSelected(Place place) {
    return selectedPlacesNotifier.value.any((item) => item.id == place.id);
  }

  static void togglePlace(Place place) {
    final list = List<Place>.from(selectedPlacesNotifier.value);
    final index = list.indexWhere((item) => item.id == place.id);
    if (index >= 0) {
      list.removeAt(index);
    } else {
      list.add(place);
    }
    selectedPlacesNotifier.value = list;
  }

  static void addPlace(Place place) {
    if (!isSelected(place)) {
      final list = List<Place>.from(selectedPlacesNotifier.value)..add(place);
      selectedPlacesNotifier.value = list;
    }
  }

  static void removePlace(Place place) {
    final list = List<Place>.from(selectedPlacesNotifier.value);
    list.removeWhere((item) => item.id == place.id);
    selectedPlacesNotifier.value = list;
  }

  static void setPlaces(List<Place> places) {
    selectedPlacesNotifier.value = List<Place>.from(places);
  }

  static void clearSelected() {
    selectedPlacesNotifier.value = [];
  }
}
