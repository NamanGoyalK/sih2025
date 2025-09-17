// Tests for UiMappers utilities
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sih_internal_app_1/src/services/local_json_loader.dart';

void main() {
  group('UiMappers.colorFromHex', () {
    test('parses 6-digit hex with # and adds full alpha', () {
      final c = UiMappers.colorFromHex('#FF6B6B');
      expect(c, const Color(0xFFFF6B6B));
    });

    test('parses 8-digit hex with # including alpha', () {
      final c = UiMappers.colorFromHex('#CC112233');
      expect(c, const Color(0xCC112233));
    });

    test('parses 6-digit hex without # and adds full alpha', () {
      final c = UiMappers.colorFromHex('4ECDC4');
      expect(c, const Color(0xFF4ECDC4));
    });
  });

  group('UiMappers.iconFromKey', () {
    test('maps known keys to icons', () {
      expect(UiMappers.iconFromKey('arrow_upward'), Icons.arrow_upward_rounded);
      expect(UiMappers.iconFromKey('directions_run'),
          Icons.directions_run_rounded);
      expect(UiMappers.iconFromKey('swap_horiz'), Icons.swap_horiz_rounded);
      expect(UiMappers.iconFromKey('fitness_center'),
          Icons.fitness_center_rounded);
      expect(UiMappers.iconFromKey('sports_gymnastics'),
          Icons.sports_gymnastics_rounded);
      expect(UiMappers.iconFromKey('straighten'), Icons.straighten_rounded);
      expect(UiMappers.iconFromKey('directions_walk'),
          Icons.directions_walk_rounded);
    });

    test('falls back to default for unknown key', () {
      expect(UiMappers.iconFromKey('unknown_key'), Icons.sports_rounded);
    });
  });
}
