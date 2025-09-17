// filepath: lib/src/services/local_json_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class LocalJsonLoader {
  static Future<dynamic> loadJson(String assetPath) async {
    final data = await rootBundle.loadString(assetPath);
    return json.decode(data);
  }
}

class UiMappers {
  // Convert hex like '#FF6B6B' to Color
  static Color colorFromHex(String hex) {
    var cleaned = hex.replaceAll('#', '').toUpperCase();
    if (cleaned.length == 6) {
      cleaned = 'FF$cleaned';
    }
    final value = int.parse(cleaned, radix: 16);
    return Color(value);
  }

  // Map string icon keys from JSON to Flutter Icons
  static IconData iconFromKey(String key) {
    switch (key) {
      case 'arrow_upward':
        return Icons.arrow_upward_rounded;
      case 'directions_run':
        return Icons.directions_run_rounded;
      case 'swap_horiz':
        return Icons.swap_horiz_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'accessibility_new':
        return Icons.accessibility_new_rounded;
      case 'sports_gymnastics':
        return Icons.sports_gymnastics_rounded;
      case 'straighten':
        return Icons.straighten_rounded;
      case 'directions_walk':
        return Icons.directions_walk_rounded;
      default:
        return Icons.sports_rounded;
    }
  }
}
