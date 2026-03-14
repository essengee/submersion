import 'package:flutter/material.dart';

import 'package:submersion/l10n/l10n_extension.dart';

/// Placeholder shown when a photo exists in the database but cannot be
/// found in this device's photo gallery. Distinct from the orphaned
/// placeholder (which means the photo was deleted).
class UnavailablePhotoPlaceholder extends StatelessWidget {
  const UnavailablePhotoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.media_unavailablePlaceholder_notOnDevice,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen version of the unavailable placeholder for the photo viewer.
class UnavailablePhotoFullScreen extends StatelessWidget {
  const UnavailablePhotoFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.media_unavailablePlaceholder_notOnDevice,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
