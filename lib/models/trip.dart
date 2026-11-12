import 'place.dart';

import 'package:flutter/material.dart';

enum TripExpenseCategory {
  transportation('Տրանսպորտ', '🚗'),
  accommodation('Կացություն', '🛏'),
  food('Սնունդ', '🍽'),
  tickets('Տոմսեր', '🎟'),
  entertainment('Ժամանց', '🎭'),
  other('Այլ', '＋');

  const TripExpenseCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

class TripExpense {
  TripExpense({
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
  });

  final TripExpenseCategory category;
  final double amount;
  final String description;
  final DateTime date;
}

class TripPlace {
  TripPlace({
    required this.place,
    required this.arrivalTime,
    this.visitMinutes = 90,
    this.notes = '',
  });

  final Place place;
  DateTime arrivalTime;
  int visitMinutes;
  String notes;
}

class TripDay {
  TripDay({required this.dayNumber, required this.date});

  final int dayNumber;
  final DateTime date;
  final List<TripPlace> places = [];
}

class Trip {
  Trip({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required List<Place> places,
    this.description = '',
    this.coverImage = '',
    this.numberOfTravelers = 1,
    this.preferences = const [],
    this.estimatedBudget = 0,
    List<TripDay>? days,
    List<TripExpense>? expenses,
  }) : days = days ?? _makeDays(startDate, endDate),
       expenses = expenses ?? [] {
    if (this.days.every((day) => day.places.isEmpty)) {
      for (final place in places) {
        this.days.first.places.add(
          TripPlace(
            place: place,
            arrivalTime: this.days.first.date.add(const Duration(hours: 9)),
          ),
        );
      }
    }
  }

  final int id;
  String name;
  DateTime startDate;
  DateTime endDate;
  String description;
  String coverImage;
  int numberOfTravelers;
  List<String> preferences;
  double estimatedBudget;
  final List<TripDay> days;
  final List<TripExpense> expenses;

  List<Place> get places => [
    for (final day in days)
      for (final visit in day.places) visit.place,
  ];

  double get actualExpenses =>
      expenses.fold(0, (total, expense) => total + expense.amount);

  String get status {
    final today = DateUtils.dateOnly(DateTime.now());
    if (today.isBefore(DateUtils.dateOnly(startDate))) return 'Առաջիկա';
    if (!today.isAfter(DateUtils.dateOnly(endDate))) return 'Ընթացքում';
    return 'Ավարտված';
  }

  Trip duplicate() {
    final copy = Trip(
      id: DateTime.now().microsecondsSinceEpoch,
      name: '$name (պատճեն)',
      startDate: startDate,
      endDate: endDate,
      places: const [],
      description: description,
      coverImage: coverImage,
      numberOfTravelers: numberOfTravelers,
      preferences: List.of(preferences),
      estimatedBudget: estimatedBudget,
    );
    for (var index = 0; index < days.length; index++) {
      if (index >= copy.days.length) break;
      for (final visit in days[index].places) {
        copy.days[index].places.add(
          TripPlace(
            place: visit.place,
            arrivalTime: copy.days[index].date.add(
              Duration(
                hours: visit.arrivalTime.hour,
                minutes: visit.arrivalTime.minute,
              ),
            ),
            visitMinutes: visit.visitMinutes,
            notes: visit.notes,
          ),
        );
      }
    }
    return copy;
  }

  static List<TripDay> _makeDays(DateTime start, DateTime end) {
    final days = <TripDay>[];
    final count =
        DateUtils.dateOnly(end).difference(DateUtils.dateOnly(start)).inDays +
        1;
    if (count < 1) {
      throw ArgumentError.value(
        end,
        'endDate',
        'Must be on or after startDate.',
      );
    }
    for (var index = 0; index < count; index++) {
      days.add(
        TripDay(
          dayNumber: index + 1,
          date: DateUtils.dateOnly(start).add(Duration(days: index)),
        ),
      );
    }
    return days;
  }
}
