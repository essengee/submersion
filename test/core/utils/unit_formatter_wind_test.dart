import 'package:flutter_test/flutter_test.dart';
import 'package:submersion/core/constants/units.dart';
import 'package:submersion/core/utils/unit_formatter.dart';
import 'package:submersion/features/settings/presentation/providers/settings_providers.dart';

void main() {
  group('UnitFormatter wind speed', () {
    late UnitFormatter metricFormatter;
    late UnitFormatter imperialFormatter;

    setUp(() {
      // Metric: defaults are already metric (depth=meters, temp=celsius, etc.)
      metricFormatter = const UnitFormatter(AppSettings());

      // Imperial: override depth to feet (wind unit is derived from depth)
      imperialFormatter = const UnitFormatter(
        AppSettings(depthUnit: DepthUnit.feet),
      );
    });

    test('formatWindSpeed converts m/s to km/h in metric', () {
      // 10 m/s = 36 km/h
      expect(metricFormatter.formatWindSpeed(10.0), '36 km/h');
    });

    test('formatWindSpeed converts m/s to knots in imperial', () {
      // 10 m/s = 19.4 kts -> rounds to 19
      expect(imperialFormatter.formatWindSpeed(10.0), '19 kts');
    });

    test('formatWindSpeed returns -- for null', () {
      expect(metricFormatter.formatWindSpeed(null), '--');
    });

    test('windSpeedSymbol returns km/h for metric', () {
      expect(metricFormatter.windSpeedSymbol, 'km/h');
    });

    test('windSpeedSymbol returns kts for imperial', () {
      expect(imperialFormatter.windSpeedSymbol, 'kts');
    });

    test('convertWindSpeed converts m/s to display unit', () {
      expect(metricFormatter.convertWindSpeed(10.0), closeTo(36.0, 0.01));
      expect(imperialFormatter.convertWindSpeed(10.0), closeTo(19.44, 0.01));
    });

    test('windSpeedToMs converts display unit back to m/s', () {
      expect(metricFormatter.windSpeedToMs(36.0), closeTo(10.0, 0.01));
      expect(imperialFormatter.windSpeedToMs(19.44), closeTo(10.0, 0.01));
    });
  });
}
