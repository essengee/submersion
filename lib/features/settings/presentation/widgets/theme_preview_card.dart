import 'package:flutter/material.dart';
import 'package:submersion/core/theme/app_theme_preset.dart';
import 'package:submersion/core/theme/app_theme_registry.dart';

class ThemePreviewCard extends StatelessWidget {
  final AppThemePreset preset;
  final bool isSelected;
  final String themeName;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.themeName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final previewTheme = AppThemeRegistry.resolveTheme(
      preset,
      Theme.of(context).brightness,
    );
    final colorScheme = previewTheme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 160,
                child: _buildPreview(colorScheme, previewTheme),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              if (isSelected) const SizedBox(width: 4),
              Text(
                themeName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(ColorScheme colorScheme, ThemeData themeData) {
    final cardShape = themeData.cardTheme.shape as RoundedRectangleBorder?;
    final cardRadius =
        cardShape?.borderRadius as BorderRadius? ?? BorderRadius.circular(12);

    return Column(
      children: [
        // Mini app bar
        Container(
          height: 28,
          color: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: Container(
            width: 48,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        // Content area with mini cards
        Expanded(
          child: Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildMiniCard(colorScheme, cardRadius),
                const SizedBox(height: 6),
                _buildMiniCard(colorScheme, cardRadius),
                const SizedBox(height: 6),
                _buildMiniCard(colorScheme, cardRadius),
              ],
            ),
          ),
        ),
        // Mini bottom nav
        Container(
          height: 24,
          color: colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (i) {
              return Container(
                width: 20,
                height: 6,
                decoration: BoxDecoration(
                  color: i == 0
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard(ColorScheme colorScheme, BorderRadius radius) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: radius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
