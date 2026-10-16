import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first/main.dart';
import 'package:first/models/city.dart';
import 'package:first/widgets/city_card.dart';
import 'package:first/screens/city_details_screen.dart';

void main() {
  testWidgets('App smoke test launches VirtualTourismApp', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VirtualTourismApp());
    expect(find.text('Virtual Tourism'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Welcome back!'), findsOneWidget);
  });

  testWidgets('CityCard renders local asset image for Gyumri', (
    WidgetTester tester,
  ) async {
    final city = City(
      id: 2,
      name: 'Gyumri',
      description: 'A historic and cultural city in northern Armenia.',
      imagePath: 'assert/images/cities/Gyumri.jpg',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CityCard(
            city: city,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Gyumri'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('CityDetailsScreen renders local asset image for Gyumri', (
    WidgetTester tester,
  ) async {
    final city = City(
      id: 2,
      name: 'Gyumri',
      description: 'A historic and cultural city in northern Armenia.',
      imagePath: 'assert/images/cities/Gyumri.jpg',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CityDetailsScreen(city: city),
      ),
    );

    expect(find.text('Gyumri'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
