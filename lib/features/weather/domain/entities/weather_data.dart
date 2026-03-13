import 'package:equatable/equatable.dart';

import 'package:submersion/core/constants/enums.dart';

/// Immutable value object for weather data fetched from an API or entered manually.
///
/// Used as the return type from WeatherService and as input to WeatherRepository
/// when persisting fetched data to a dive record.
class WeatherData extends Equatable {
  final double? windSpeed; // m/s
  final CurrentDirection? windDirection;
  final CloudCover? cloudCover;
  final Precipitation? precipitation;
  final double? humidity; // 0-100
  final double? airTemp; // celsius
  final double? surfacePressure; // bar
  final String? description;

  const WeatherData({
    this.windSpeed,
    this.windDirection,
    this.cloudCover,
    this.precipitation,
    this.humidity,
    this.airTemp,
    this.surfacePressure,
    this.description,
  });

  @override
  List<Object?> get props => [
    windSpeed,
    windDirection,
    cloudCover,
    precipitation,
    humidity,
    airTemp,
    surfacePressure,
    description,
  ];
}
