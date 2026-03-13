import 'package:flutter_test/flutter_test.dart';
import 'package:submersion/core/constants/enums.dart';
import 'package:submersion/features/weather/domain/entities/weather_data.dart';

void main() {
  group('WeatherData', () {
    test('can be constructed with all fields', () {
      final data = WeatherData(
        windSpeed: 5.5,
        windDirection: CurrentDirection.north,
        cloudCover: CloudCover.clear,
        precipitation: Precipitation.none,
        humidity: 60.0,
        airTemp: 28.0,
        surfacePressure: 1.013,
        description: 'Clear skies',
      );

      expect(data.windSpeed, 5.5);
      expect(data.windDirection, CurrentDirection.north);
      expect(data.cloudCover, CloudCover.clear);
      expect(data.precipitation, Precipitation.none);
      expect(data.humidity, 60.0);
      expect(data.airTemp, 28.0);
      expect(data.surfacePressure, 1.013);
      expect(data.description, 'Clear skies');
    });

    test('defaults are all null', () {
      const data = WeatherData();
      expect(data.windSpeed, isNull);
      expect(data.windDirection, isNull);
      expect(data.cloudCover, isNull);
      expect(data.precipitation, isNull);
      expect(data.humidity, isNull);
      expect(data.airTemp, isNull);
      expect(data.surfacePressure, isNull);
      expect(data.description, isNull);
    });

    test('equality works', () {
      const data1 = WeatherData(windSpeed: 5.5, humidity: 60.0);
      const data2 = WeatherData(windSpeed: 5.5, humidity: 60.0);
      const data3 = WeatherData(windSpeed: 10.0, humidity: 60.0);

      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
    });
  });
}
