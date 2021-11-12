import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;

  static final categoryDictionary = {
  'Transports': Icon(Icons.directions_car_filled_sharp),
  'Education': Icon(Icons.book_outlined),
  'Healthcare': Icon(Icons.health_and_safety_outlined),
  'Saving, Investing, & Debt Payments': Icon(Icons.monetization_on_outlined),
  'Utilities': Icon(Icons.emoji_objects_outlined),
  'Food': Icon(Icons.flatware_outlined),
  'Personal spending': Icon(Icons.person_outline),
  'Recreation & Entertainment': Icon(Icons.cake_outlined),
  'Miscellaneous': Icon(Icons.not_listed_location_outlined),
  
};

  Category({
    required this.id,
    required this.name
  });
}
