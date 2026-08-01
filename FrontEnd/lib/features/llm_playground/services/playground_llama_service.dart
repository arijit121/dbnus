import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:llamadart/llamadart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';

/// Independent service for LLM Playground feature.
class PlaygroundLlamaService {
  LlamaEngine? _engine;
  ChatSession? _session;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<ModelSource> _resolveSource(String modelPath) async {
    if (modelPath.startsWith('http://') || modelPath.startsWith('https://')) {
      return ModelSource.url(Uri.parse(modelPath));
    }

    final cleanPath = modelPath.startsWith('asset:')
        ? modelPath.replaceFirst('asset:', '')
        : modelPath;

    if (cleanPath.startsWith('assets/')) {
      if (kIsWeb) {
        throw Exception(
          'Bundled local asset GGUF models (assets/models/ai/...) are reserved for native mobile and desktop apps (Android, iOS, Windows, macOS, Linux). On Web, please use a remote model URL.',
        );
      }
      try {
        final byteData = await rootBundle.load(cleanPath);
        final fileName = cleanPath.split('/').last;
        final dir = await getApplicationSupportDirectory();
        final file = File('${dir.path}/$fileName');

        if (!await file.exists() || (await file.length()) != byteData.lengthInBytes) {
          final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
          await file.writeAsBytes(bytes, flush: true);
        }
        return ModelSource.path(file.path);
      } catch (e) {
        AppLog.e('PlaygroundLlamaService asset error: $e');
        rethrow;
      }
    }

    return ModelSource.path(modelPath);
  }

  Future<void> initialize({
    required String modelPath,
    LlamaBackend? backend,
    ModelParams? modelParams,
  }) async {
    try {
      if (kIsWeb) {
        await JsProvider.loadLlamaWebGpuBridge();
      }
      final selectedBackend = backend ?? LlamaBackend();
      _engine = LlamaEngine(selectedBackend);

      final source = await _resolveSource(modelPath);

      await _engine?.loadModelSource(
        source,
        modelParams: modelParams ?? const ModelParams(),
      );
      _session = ChatSession(_engine!);
      _isInitialized = true;
      AppLog.i('PlaygroundLlamaService initialized: $modelPath');
    } catch (e, stackTrace) {
      _isInitialized = false;
      AppLog.e('Failed to initialize PlaygroundLlamaService: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  void resetSession() {
    if (_engine != null && _isInitialized) {
      _session = ChatSession(_engine!);
      AppLog.i('PlaygroundLlamaService session reset.');
    }
  }

  Stream<LlamaCompletionChunk>? createChatStream(String prompt, {GenerationParams? generationParams}) {
    if (!_isInitialized || _session == null) {
      AppLog.e('PlaygroundLlamaService is not initialized.');
      return null;
    }
    try {
      final message = LlamaTextContent(prompt);
      return _session?.create([message], params: generationParams);
    } catch (e, stackTrace) {
      AppLog.e('Error in PlaygroundLlamaService chat stream: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> dispose() async {
    try {
      _session = null;
      await _engine?.dispose();
      _engine = null;
      _isInitialized = false;
      AppLog.i('PlaygroundLlamaService disposed.');
    } catch (e, stackTrace) {
      AppLog.e('Error disposing PlaygroundLlamaService: $e', error: e, stackTrace: stackTrace);
    }
  }
}
