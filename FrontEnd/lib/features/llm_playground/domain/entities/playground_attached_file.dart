import 'package:flutter/foundation.dart';

class PlaygroundAttachedFile {
  final String name;
  final String? path;
  final String content;
  final int sizeInBytes;
  final bool isImage;
  final Uint8List? bytes;

  const PlaygroundAttachedFile({
    required this.name,
    this.path,
    required this.content,
    required this.sizeInBytes,
    this.isImage = false,
    this.bytes,
  });

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
