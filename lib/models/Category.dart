import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;

  static final icon = "ICON";
  static final color = "COLOR";

  static final categoryDictionary = {
    'Transports': {
      icon: Icon(Icons.directions_car_filled_sharp),
      color: Colors.red
    },
    'Education': {icon: Icon(Icons.book_outlined), color: Colors.pink},
    'Healthcare': {
      icon: Icon(Icons.health_and_safety_outlined),
      color: Colors.blue
    },
    'Saving, Investing, & Debt Payments': {
      icon: Icon(Icons.monetization_on_outlined),
      color: Colors.green
    },
    'Utilities': {
      icon: Icon(Icons.emoji_objects_outlined),
      color: Colors.yellow
    },
    'Food': {icon: Icon(Icons.flatware_outlined), color: Colors.black},
    'Personal spending': {
      icon: Icon(Icons.person_outline),
      color: Colors.purple
    },
    'Recreation & Entertainment': {
      icon: Icon(Icons.cake_outlined),
      color: Colors.grey
    },
    'Miscellaneous': {
      icon: Icon(Icons.not_listed_location_outlined),
      color: Colors.orange
    }
  };

  Category({required this.id, required this.name});
}
