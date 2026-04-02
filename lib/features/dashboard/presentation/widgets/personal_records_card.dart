import 'package:flutter/material.dart';
import 'package:submersion/core/providers/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:submersion/core/utils/unit_formatter.dart';
import 'package:submersion/features/settings/presentation/providers/settings_providers.dart';
import 'package:submersion/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:submersion/l10n/l10n_extension.dart';

/// Card showing personal dive records as a compact vertical list
class PersonalRecordsCard extends ConsumerWidget {
  const PersonalRecordsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(personalRecordsProvider);
    final settings = ref.watch(settingsProvider);
    final units = UnitFormatter(settings);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final bodyMedium = theme.textTheme.bodyMedium;

    return recordsAsync.when(
      data: (records) {
        if (!records.hasRecords) {
          return const SizedBox.shrink();
        }

        final rows = <Widget>[];

        if (records.deepestDive != null) {
          final displayDepth = units.convertDepth(
            records.deepestDive!.maxDepth!,
          );
          rows.add(
            _RecordRow(
              label: context.l10n.dashboard_personalRecords_deepest,
              value: '${displayDepth.toStringAsFixed(1)}${units.depthSymbol}',
              color: Colors.indigo,
              onTap: () => context.push('/dives/${records.deepestDive!.id}'),
            ),
          );
        }

        if (records.longestDive != null) {
          rows.add(
            _RecordRow(
              label: context.l10n.dashboard_personalRecords_longest,
              value: '${records.longestDive!.bottomTime!.inMinutes}min',
              color: Colors.teal,
              onTap: () => context.push('/dives/${records.longestDive!.id}'),
            ),
          );
        }

        if (records.coldestDive != null) {
          final displayTemp = units.convertTemperature(
            records.coldestDive!.waterTemp!,
          );
          rows.add(
            _RecordRow(
              label: context.l10n.dashboard_personalRecords_coldest,
              value:
                  '${displayTemp.toStringAsFixed(0)}${units.temperatureSymbol}',
              color: Colors.blue,
              onTap: () => context.push('/dives/${records.coldestDive!.id}'),
            ),
          );
        }

        if (records.warmestDive != null) {
          final displayTemp = units.convertTemperature(
            records.warmestDive!.waterTemp!,
          );
          rows.add(
            _RecordRow(
              label: context.l10n.dashboard_personalRecords_warmest,
              value:
                  '${displayTemp.toStringAsFixed(0)}${units.temperatureSymbol}',
              color: Colors.orange,
              onTap: () => context.push('/dives/${records.warmestDive!.id}'),
            ),
          );
        }

        if (rows.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 16, color: primary),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.dashboard_personalRecords_sectionTitle,
                      style: bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...rows,
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _RecordRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _RecordRow({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    final bodySmall = theme.textTheme.bodySmall;
    final bodyMedium = theme.textTheme.bodyMedium;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(label, style: bodySmall?.copyWith(color: onSurfaceVariant)),
            const Spacer(),
            Text(
              value,
              style: bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
