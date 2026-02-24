import 'package:submersion/features/dive_log/domain/entities/dive.dart';

/// Result of extracting CNS start/end from dive computer samples.
typedef ComputerCnsResult = ({double cnsStart, double cnsEnd});

/// Extracts cnsStart and cnsEnd from computer-reported per-sample CNS data.
///
/// Scans the profile for the first and last non-null CNS values.
/// Returns null if no computer CNS samples exist.
ComputerCnsResult? extractComputerCns(List<DiveProfilePoint> profile) {
  double? first;
  double? last;
  for (final point in profile) {
    if (point.cns != null) {
      first ??= point.cns!;
      last = point.cns!;
    }
  }
  if (first == null || last == null) return null;
  return (cnsStart: first, cnsEnd: last);
}

/// Whether the profile contains any computer-reported CNS samples.
bool hasComputerCns(List<DiveProfilePoint> profile) {
  return profile.any((p) => p.cns != null);
}
