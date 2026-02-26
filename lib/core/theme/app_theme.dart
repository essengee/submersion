import 'package:flutter/material.dart';

import 'package:submersion/core/theme/full_themes/submersion_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => submersionLight;

  static ThemeData get dark => submersionDark;
}
