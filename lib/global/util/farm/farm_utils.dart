import 'package:flutter/material.dart';

class FarmUtils {
  static List<Map<String, dynamic>> animalsData = [
    {
      'type': 'sheep',
      'image': 'assets/svg/farm/animal2.svg',
      'color': const Color(0xFF78B833)
    },
    {
      'type': 'cow',
      'image': 'assets/svg/farm/animal3.svg',
      'color': const Color(0xFF977016)
    },
    {
      'type': 'goat',
      'image': 'assets/svg/farm/animal4.svg',
      'color': const Color(0xFF0C83B6)
    },
    {
      'type': 'camel',
      'image': 'assets/svg/farm/animal1.svg',
      'color': const Color(0xFFD2A848)
    },
  ];

  static Map<String, dynamic> getAnimalByType(String type) {
    try {
      return animalsData.firstWhere(
        (animal) => animal['type'].toLowerCase() == type.toLowerCase(),
      );
    } catch (e) {
      // fallback if type not found
      return animalsData[0];
    }
  }

  static bool isMale(String? gender) {
    if (gender == null) return false;

    final normalized = gender.trim().toLowerCase();

    // English variations
    if (["male", "m"].contains(normalized)) return true;
    if (["female", "f"].contains(normalized)) return false;

    // Arabic variations
    if (["ذكر", "ذكر ", "زكر"].contains(normalized)) return true; // male
    if (["انثى", "أنثى", "انثي"].contains(normalized)) return false; // female

    // Urdu variations
    if (["مرد"].contains(normalized)) return true; // male
    if (["عورت"].contains(normalized)) return false; // female

    return false; // unknown
  }
}
