import 'dart:io';

import 'package:flutter/material.dart';

import 'package:submersion/l10n/l10n_extension.dart';

/// Bottom sheet presenting export options: Save to File and Share.
///
/// Share option is hidden on Windows and Linux (no share sheet support).
class ExportBottomSheet extends StatelessWidget {
  final VoidCallback onSaveToFile;
  final VoidCallback? onShare;

  const ExportBottomSheet({
    super.key,
    required this.onSaveToFile,
    this.onShare,
  });

  /// Shows the bottom sheet. Actions are via callbacks; nothing is returned.
  static void show(
    BuildContext context, {
    required VoidCallback onSaveToFile,
    required VoidCallback onShare,
  }) {
    final showShare = Platform.isIOS || Platform.isMacOS || Platform.isAndroid;

    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ExportBottomSheet(
        onSaveToFile: () {
          Navigator.of(context).pop();
          onSaveToFile();
        },
        onShare: showShare
            ? () {
                Navigator.of(context).pop();
                onShare();
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n.backup_export_bottomSheet_title,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: Text(context.l10n.backup_export_saveToFile),
              subtitle: Text(context.l10n.backup_export_saveToFile_subtitle),
              onTap: onSaveToFile,
            ),
            if (onShare != null)
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(context.l10n.backup_export_share),
                subtitle: Text(context.l10n.backup_export_share_subtitle),
                onTap: onShare,
              ),
          ],
        ),
      ),
    );
  }
}
