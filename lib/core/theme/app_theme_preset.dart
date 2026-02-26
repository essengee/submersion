import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppThemePreset extends Equatable {
  final String id;
  final String nameKey;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  // ignore: prefer_const_constructors_in_immutables
  AppThemePreset({
    required this.id,
    required this.nameKey,
    required this.lightTheme,
    required this.darkTheme,
  });

  // Presets are registry singletons identified by id.
  @override
  List<Object?> get props => [id];
}
