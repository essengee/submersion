import 'package:equatable/equatable.dart';
import 'package:submersion/features/dive_log/domain/entities/dive.dart';

/// A dive found during trip date-range scanning.
/// Wraps the dive with info about its current trip assignment (if any).
class DiveCandidate extends Equatable {
  final Dive dive;
  final String? currentTripId;
  final String? currentTripName;

  const DiveCandidate({
    required this.dive,
    this.currentTripId,
    this.currentTripName,
  });

  bool get isUnassigned => currentTripId == null;

  @override
  List<Object?> get props => [dive, currentTripId, currentTripName];
}
