import 'package:flutter/material.dart';

import '../models/place.dart';

enum CategoryType {
  mountains('Լեռներ', 'Լեռնային գյուղեր, գագաթներ և լեռնային փախուստներ', Icons.hiking_rounded, Color(0xFF2E7D32)),
  churches('Եկեղեցիներ', 'Եկեղեցիներ, վանքեր և սրբավայրեր', Icons.church_rounded, Color(0xFF6A1B9A)),
  lakes('Լճեր և գետեր', 'Լճեր, գետեր և ջրային ուղղություններ', Icons.water_rounded, Color(0xFF1565C0)),
  culture('Մշակույթ', 'Միջազմային, հրապարակներ և մշակութային հուշարձաններ', Icons.museum_rounded, Color(0xFFE65100)),
  nature('Բնություն', 'Անտառներ և բնության հրաշալիքներ', Icons.park_rounded, Color(0xFF00838F)),
  all('Բոլոր վայրերը', 'Զննեք Հայաստանի բոլոր առաջարկները', Icons.explore_rounded, Color(0xFF17453D));

  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const CategoryType(this.label, this.description, this.icon, this.color);
}

List<Place> getPlacesByCategory(List<City> allCities, CategoryType type) {
  if (type == CategoryType.all) {
    final all = <Place>[];
    for (final city in allCities) {
      all.addAll(city.places);
    }
    return all;
  }

  final all = <Place>[];
  for (final city in allCities) {
    for (final place in city.places) {
      if (_matchesCategory(place, type)) {
        all.add(Place(
          id: place.id,
          name: place.name,
          type : place.type,
          description: place.description,
          imagePath: place.imagePath,
          latitude: place.latitude,
          longitude: place.longitude,
          rating: place.rating,
          city: city.name,
        ));
      }
    }
  }
  return all;
}

bool _matchesCategory(Place place, CategoryType type) {
  final placeType = place.type.trim().toLowerCase();

  switch (type) {
    case CategoryType.mountains:
      return placeType == 'լեռ';

    case CategoryType.churches:
      return placeType == 'եկեղեցի' ||
          placeType == 'վանք' ||
          placeType == 'տաճար';

    case CategoryType.lakes:
      return placeType == 'լիճ' ||
          placeType == 'գետ';

    case CategoryType.culture:
      return placeType == 'թանգարան' ||
          placeType == 'հուշահամալիր' ||
          placeType == 'ամրոց';

    case CategoryType.nature:
      return placeType == 'կիրճ' ||
          placeType == 'անտառ' ||
          placeType == 'բնական';

    case CategoryType.all:
      return true;
  }
}
