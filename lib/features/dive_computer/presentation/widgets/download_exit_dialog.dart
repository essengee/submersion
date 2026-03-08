import 'package:flutter/material.dart';

/// Shows a confirmation dialog when the user tries to navigate away
/// during an active dive computer download.
///
/// Returns `true` if the user confirmed they want to leave (and cancel
/// the download), `false` if they chose to stay or dismissed the dialog.
Future<bool> showDownloadExitConfirmation(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Download in Progress'),
      content: const Text(
        'Leaving will cancel the current download from your dive computer. '
        'Are you sure?',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Stay'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Leave'),
        ),
      ],
    ),
  );
  return result ?? false;
}
