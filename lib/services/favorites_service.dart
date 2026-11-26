import '../models/place.dart';

class FavoritesService {
  static final List<Place> _favorites = [];

  static List<Place> get favorites => _favorites;

  static bool isFavorite(Place place) {
    return _favorites.any((item) => item.id == place.id);
  }

  static void toggleFavorite(Place place) {
    if (isFavorite(place)) {
      _favorites.removeWhere((item) => item.id == place.id);
    } else {
      _favorites.add(place);
    }
  }
}
