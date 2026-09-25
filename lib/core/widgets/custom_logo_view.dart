import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class CustomLogoView extends StatelessWidget {
  final String source;
  final double size;
  final Widget? fallback;

  const CustomLogoView({
    super.key,
    required this.source,
    required this.size,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final cleanSource = source.trim();

    if (cleanSource.startsWith('http://') || cleanSource.startsWith('https://')) {
      return Image.network(
        cleanSource,
        width: size,
        height: size,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: size * 0.35,
              height: size * 0.35,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, _, _) => _buildFallback(),
      );
    }

    if (cleanSource.startsWith('data:image')) {
      try {
        final commaIdx = cleanSource.indexOf(',');
        final base64Str = commaIdx != -1 ? cleanSource.substring(commaIdx + 1) : cleanSource;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _buildFallback(),
        );
      } catch (_) {
        return _buildFallback();
      }
    }

    try {
      final file = File(cleanSource);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _buildFallback(),
        );
      }
    } catch (_) {}

    return _buildFallback();
  }

  Widget _buildFallback() {
    return fallback ??
        Icon(
          Icons.business_rounded,
          size: size * 0.5,
          color: Colors.white70,
        );
  }
}
