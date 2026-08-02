import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:llamadart/llamadart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'llm_playground_data_source.dart';

class LlmPlaygroundLocalDataSourceImpl implements LlmPlaygroundDataSource {
  LlamaEngine? _engine;
  ChatSession? _session;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  Future<ModelSource> _resolveLocalSource(String modelPath) async {
    final cleanPath = modelPath.startsWith('asset:')
        ? modelPath.replaceFirst('asset:', '')
        : modelPath;

    if (cleanPath.startsWith('assets/')) {
      if (kIsWeb) {
        throw Exception(
          'Bundled local asset GGUF models are reserved for native mobile and desktop apps (Android, iOS, Windows, macOS, Linux). On Web, please use a remote model URL.',
        );
      }
      try {
        final byteData = await rootBundle.load(cleanPath);
        final fileName = cleanPath.split('/').last;
        final dir = await getApplicationSupportDirectory();
        final file = File('${dir.path}/$fileName');

        if (!await file.exists() ||
            (await file.length()) != byteData.lengthInBytes) {
          final bytes = byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
          await file.writeAsBytes(bytes, flush: true);
        }
        return ModelSource.path(file.path);
      } catch (e) {
        AppLog.e('LlmPlaygroundLocalDataSourceImpl asset error: $e');
        rethrow;
      }
    }

    return ModelSource.path(modelPath);
  }

  @override
  Future<void> initialize({
    required String modelPath,
    LlamaBackend? backend,
    ModelParams? modelParams,
  }) async {
    try {
      final selectedBackend = backend ?? LlamaBackend();
      _engine = LlamaEngine(selectedBackend);

      final source = await _resolveLocalSource(modelPath);

      await _engine?.loadModelSource(
        source,
        modelParams: modelParams ?? const ModelParams(),
      );
      _session = ChatSession(_engine!);
      _isInitialized = true;
      AppLog.i('LlmPlaygroundLocalDataSourceImpl initialized: $modelPath');
    } catch (e, stackTrace) {
      _isInitialized = false;
      AppLog.e('Failed to initialize LlmPlaygroundLocalDataSourceImpl: $e',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  void resetSession() {
    if (_engine != null && _isInitialized) {
      _session = ChatSession(_engine!);
      AppLog.i('LlmPlaygroundLocalDataSourceImpl session reset.');
    }
  }

  @override
  Stream<LlamaCompletionChunk>? createChatStream(
    String prompt, {
    GenerationParams? generationParams,
  }) {
    if (!_isInitialized || _session == null) {
      AppLog.e('LlmPlaygroundLocalDataSourceImpl is not initialized.');
      return null;
    }
    try {
      final message = LlamaTextContent(prompt);
      return _session?.create([message], params: generationParams);
    } catch (e, stackTrace) {
      AppLog.e('Error in LlmPlaygroundLocalDataSourceImpl chat stream: $e',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      _session = null;
      await _engine?.dispose();
      _engine = null;
      _isInitialized = false;
      AppLog.i('LlmPlaygroundLocalDataSourceImpl disposed.');
    } catch (e, stackTrace) {
      AppLog.e('Error disposing LlmPlaygroundLocalDataSourceImpl: $e',
          error: e, stackTrace: stackTrace);
    }
  }
}
