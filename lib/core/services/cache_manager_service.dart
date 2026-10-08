import 'dart:io';
import 'package:flutter/painting.dart';
import 'schema_catalog_service.dart';

class CacheManagerService {
  static final CacheManagerService instance = CacheManagerService._();
  CacheManagerService._();

  Directory get _appCacheDir => Directory('${Directory.systemTemp.path}/morfin_cache');

  Future<int> getCacheSizeBytes() async {
    int totalBytes = 0;

    // 1. Flutter in-memory image cache
    try {
      totalBytes += PaintingBinding.instance.imageCache.currentSizeBytes;
    } catch (_) {}

    // 2. Volatile application temporary directory
    try {
      if (_appCacheDir.existsSync()) {
        final items = _appCacheDir.listSync(recursive: true, followLinks: false);
        for (final item in items) {
          if (item is File) {
            try {
              totalBytes += item.lengthSync();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}

    return totalBytes;
  }

  Future<String> getCacheSizeDescription() async {
    final bytes = await getCacheSizeBytes();
    if (bytes <= 0) {
      return '0 KB • Online Mode';
    } else if (bytes < 1024) {
      return '$bytes B • Online Mode';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB • Online Mode';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB • Online Mode';
    }
  }

  Future<void> clearCache() async {
    // Clear Flutter memory images
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (_) {}

    // Clear schema metadata memory cache
    SchemaCatalogService.instance.clearCache();

    // Clean ephemeral temporary files safely within app-scoped dir
    try {
      if (_appCacheDir.existsSync()) {
        _appCacheDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  }
}
