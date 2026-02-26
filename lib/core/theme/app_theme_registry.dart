import 'package:flutter/material.dart';
import 'package:submersion/core/theme/app_theme_preset.dart';
import 'package:submersion/core/theme/full_themes/console_theme.dart';
import 'package:submersion/core/theme/full_themes/deep_theme.dart';
import 'package:submersion/core/theme/full_themes/minimalist_theme.dart';
import 'package:submersion/core/theme/full_themes/submersion_theme.dart';
import 'package:submersion/core/theme/full_themes/tropical_theme.dart';

class AppThemeRegistry {
  AppThemeRegistry._();

  static final List<AppThemePreset> presets = List.unmodifiable([
    AppThemePreset(
      id: 'submersion',
      nameKey: 'theme_submersion',
      lightTheme: submersionLight,
      darkTheme: submersionDark,
    ),
    AppThemePreset(
      id: 'console',
      nameKey: 'theme_console',
      lightTheme: consoleLight,
      darkTheme: consoleDark,
    ),
    AppThemePreset(
      id: 'tropical',
      nameKey: 'theme_tropical',
      lightTheme: tropicalLight,
      darkTheme: tropicalDark,
    ),
    AppThemePreset(
      id: 'minimalist',
      nameKey: 'theme_minimalist',
      lightTheme: minimalistLight,
      darkTheme: minimalistDark,
    ),
    AppThemePreset(
      id: 'deep',
      nameKey: 'theme_deep',
      lightTheme: deepLight,
      darkTheme: deepDark,
    ),
  ]);

  /// Find a preset by ID, falling back to Submersion if not found.
  static AppThemePreset findById(String id) {
    return presets.firstWhere((p) => p.id == id, orElse: () => presets.first);
  }

  /// Resolve the concrete ThemeData for a preset at a given brightness.
  static ThemeData resolveTheme(AppThemePreset preset, Brightness brightness) {
    return brightness == Brightness.light
        ? preset.lightTheme
        : preset.darkTheme;
  }
}
