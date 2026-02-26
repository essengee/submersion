import 'package:flutter/material.dart';
import 'package:submersion/core/providers/provider.dart';
import 'package:submersion/core/theme/app_theme_registry.dart';
import 'package:submersion/features/settings/presentation/providers/settings_providers.dart';
import 'package:submersion/features/settings/presentation/widgets/theme_preview_card.dart';
import 'package:submersion/l10n/l10n_extension.dart';

class ThemeGalleryPage extends ConsumerWidget {
  const ThemeGalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPresetId = ref.watch(
      settingsProvider.select((s) => s.themePresetId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings_themes_title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 16,
          mainAxisExtent: 200,
        ),
        itemCount: AppThemeRegistry.presets.length,
        itemBuilder: (context, index) {
          final preset = AppThemeRegistry.presets[index];
          return ThemePreviewCard(
            preset: preset,
            isSelected: preset.id == currentPresetId,
            themeName: _resolveThemeName(context, preset.nameKey),
            onTap: () {
              ref.read(settingsProvider.notifier).setThemePresetId(preset.id);
            },
          );
        },
      ),
    );
  }

  String _resolveThemeName(BuildContext context, String nameKey) {
    final l10n = context.l10n;
    switch (nameKey) {
      case 'theme_submersion':
        return l10n.theme_submersion;
      case 'theme_console':
        return l10n.theme_console;
      case 'theme_tropical':
        return l10n.theme_tropical;
      case 'theme_minimalist':
        return l10n.theme_minimalist;
      case 'theme_deep':
        return l10n.theme_deep;
      default:
        return nameKey;
    }
  }
}
