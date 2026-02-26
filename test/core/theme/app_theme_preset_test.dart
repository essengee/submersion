import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submersion/core/theme/app_theme_preset.dart';

void main() {
  group('AppThemePreset', () {
    test('stores id, nameKey, lightTheme, and darkTheme', () {
      final light = ThemeData.light();
      final dark = ThemeData.dark();
      final preset = AppThemePreset(
        id: 'test',
        nameKey: 'theme_test',
        lightTheme: light,
        darkTheme: dark,
      );

      expect(preset.id, 'test');
      expect(preset.nameKey, 'theme_test');
      expect(preset.lightTheme, light);
      expect(preset.darkTheme, dark);
    });

    test('equality based on id', () {
      final light = ThemeData.light();
      final dark = ThemeData.dark();
      final a = AppThemePreset(
        id: 'ocean',
        nameKey: 'theme_ocean',
        lightTheme: light,
        darkTheme: dark,
      );
      final b = AppThemePreset(
        id: 'ocean',
        nameKey: 'theme_ocean',
        lightTheme: light,
        darkTheme: dark,
      );
      expect(a, equals(b));
    });

    test('presets with different ids are not equal', () {
      final light = ThemeData.light();
      final dark = ThemeData.dark();
      final a = AppThemePreset(
        id: 'ocean',
        nameKey: 'theme_ocean',
        lightTheme: light,
        darkTheme: dark,
      );
      final b = AppThemePreset(
        id: 'sunset',
        nameKey: 'theme_sunset',
        lightTheme: light,
        darkTheme: dark,
      );
      expect(a, isNot(equals(b)));
    });
  });
}
