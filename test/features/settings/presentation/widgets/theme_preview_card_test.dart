import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:submersion/core/theme/app_theme_registry.dart';
import 'package:submersion/features/settings/presentation/widgets/theme_preview_card.dart';

void main() {
  group('ThemePreviewCard', () {
    testWidgets('renders theme name', (tester) async {
      final preset = AppThemeRegistry.findById('submersion');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemePreviewCard(
              preset: preset,
              isSelected: false,
              themeName: 'Submersion',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Submersion'), findsOneWidget);
    });

    testWidgets('shows check icon when selected', (tester) async {
      final preset = AppThemeRegistry.findById('submersion');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemePreviewCard(
              preset: preset,
              isSelected: true,
              themeName: 'Submersion',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      final preset = AppThemeRegistry.findById('submersion');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ThemePreviewCard(
              preset: preset,
              isSelected: false,
              themeName: 'Submersion',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Submersion'));
      expect(tapped, true);
    });
  });
}
