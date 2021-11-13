import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;

  static final icon = "ICON";
  static final color = "COLOR";

  static final List<String> categoryOrder = [
    "Transports",
    "Education",
    "Healthcare",
    "Finances",
    "Utilities",
    "Food",
    "Personal",
    "Recreation",
    "Miscellaneous"
  ];

  static final categoryDictionary = {
    categoryOrder[0]: {
      icon: Icon(Icons.directions_car_filled_sharp),
      color: Colors.red
    },
    categoryOrder[1]: {icon: Icon(Icons.book_outlined), color: Colors.pink},
    categoryOrder[2]: {
      icon: Icon(Icons.health_and_safety_outlined),
      color: Colors.blue
    },
    categoryOrder[3]: {
      icon: Icon(Icons.monetization_on_outlined),
      color: Colors.green
    },
    categoryOrder[4]: {
      icon: Icon(Icons.emoji_objects_outlined),
      color: Colors.yellow
    },
    categoryOrder[5]: {
      icon: Icon(Icons.flatware_outlined),
      color: Colors.black
    },
    categoryOrder[6]: {icon: Icon(Icons.person_outline), color: Colors.purple},
    categoryOrder[7]: {icon: Icon(Icons.cake_outlined), color: Colors.grey},
    categoryOrder[8]: {
      icon: Icon(Icons.not_listed_location_outlined),
      color: Colors.orange
    }
  };

  Category({required this.id, required this.name});
}
