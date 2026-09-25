import 'dart:io';
import 'package:flutter/painting.dart';

class CacheManagerService {
  static final CacheManagerService instance = CacheManagerService._();
  CacheManagerService._();

  Future<int> getCacheSizeBytes() async {
    int totalBytes = 0;

    // 1. Flutter in-memory image cache
    try {
      totalBytes += PaintingBinding.instance.imageCache.currentSizeBytes;
    } catch (_) {}

    // 2. Volatile OS temporary directory
    try {
      final tempDir = Directory.systemTemp;
      if (tempDir.existsSync()) {
        final entities = tempDir.listSync(recursive: true, followLinks: false);
        for (final entity in entities) {
          if (entity is File) {
            try {
              totalBytes += entity.lengthSync();
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

    // Clean ephemeral temporary files
    try {
      final tempDir = Directory.systemTemp;
      if (tempDir.existsSync()) {
        final entities = tempDir.listSync(recursive: false);
        for (final entity in entities) {
          try {
            if (entity is File) {
              entity.deleteSync();
            } else if (entity is Directory) {
              entity.deleteSync(recursive: true);
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
  }
}
