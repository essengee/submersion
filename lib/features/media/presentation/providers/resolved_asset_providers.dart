import 'dart:typed_data';

import 'package:submersion/core/providers/provider.dart';
import 'package:submersion/features/media/data/repositories/local_asset_cache_repository.dart';
import 'package:submersion/features/media/data/services/asset_resolution_service.dart';
import 'package:submersion/features/media/domain/entities/media_item.dart';
import 'package:submersion/features/media/presentation/providers/photo_picker_providers.dart';

/// Provider for the asset resolution service (singleton).
final assetResolutionServiceProvider = Provider<AssetResolutionService>((ref) {
  return AssetResolutionService(
    cacheRepository: LocalAssetCacheRepository(),
    photoPickerService: ref.watch(photoPickerServiceProvider),
  );
});

/// Result type for resolved asset loading.
/// Wraps either loaded bytes or an unavailable status.
class ResolvedAssetResult {
  final Uint8List? bytes;
  final ResolutionStatus status;

  const ResolvedAssetResult({this.bytes, required this.status});

  bool get isAvailable => status == ResolutionStatus.resolved && bytes != null;
  bool get isUnavailable => status == ResolutionStatus.unavailable;
}

/// Resolved thumbnail provider for displaying already-linked media.
///
/// Resolves the media item's asset ID on the current device via
/// AssetResolutionService, then loads the thumbnail.
/// Use this instead of assetThumbnailProvider for display contexts.
final resolvedThumbnailProvider =
    FutureProvider.family<ResolvedAssetResult, MediaItem>((ref, item) async {
      final service = ref.watch(assetResolutionServiceProvider);
      final resolution = await service.resolveAssetId(item);

      if (resolution.status == ResolutionStatus.unavailable ||
          resolution.localAssetId == null) {
        return const ResolvedAssetResult(status: ResolutionStatus.unavailable);
      }

      final pickerService = ref.watch(photoPickerServiceProvider);
      final bytes = await pickerService.getThumbnail(resolution.localAssetId!);

      // If cached ID no longer loads, the photo was deleted — clear cache
      if (bytes == null) {
        final cache = LocalAssetCacheRepository();
        await cache.clearEntry(item.id);
        return const ResolvedAssetResult(status: ResolutionStatus.unavailable);
      }

      return ResolvedAssetResult(
        bytes: bytes,
        status: ResolutionStatus.resolved,
      );
    });

/// Resolved full-resolution provider for photo viewer.
///
/// Same pattern as resolvedThumbnailProvider but loads full-res bytes.
final resolvedFullResolutionProvider =
    FutureProvider.family<ResolvedAssetResult, MediaItem>((ref, item) async {
      final service = ref.watch(assetResolutionServiceProvider);
      final resolution = await service.resolveAssetId(item);

      if (resolution.status == ResolutionStatus.unavailable ||
          resolution.localAssetId == null) {
        return const ResolvedAssetResult(status: ResolutionStatus.unavailable);
      }

      final pickerService = ref.watch(photoPickerServiceProvider);
      final bytes = await pickerService.getFileBytes(resolution.localAssetId!);

      if (bytes == null) {
        final cache = LocalAssetCacheRepository();
        await cache.clearEntry(item.id);
        return const ResolvedAssetResult(status: ResolutionStatus.unavailable);
      }

      return ResolvedAssetResult(
        bytes: bytes,
        status: ResolutionStatus.resolved,
      );
    });

/// Resolved file path provider for video playback.
final resolvedFilePathProvider = FutureProvider.family<String?, MediaItem>((
  ref,
  item,
) async {
  final service = ref.watch(assetResolutionServiceProvider);
  final resolution = await service.resolveAssetId(item);

  if (resolution.status == ResolutionStatus.unavailable ||
      resolution.localAssetId == null) {
    return null;
  }

  final pickerService = ref.watch(photoPickerServiceProvider);
  return pickerService.getFilePath(resolution.localAssetId!);
});
