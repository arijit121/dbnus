import 'package:flutter/foundation.dart';
import 'package:llamadart/llamadart.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'llm_playground_data_source.dart';

class LlmPlaygroundRemoteDataSourceImpl implements LlmPlaygroundDataSource {
  LlamaEngine? _engine;
  ChatSession? _session;
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
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

      final source = ModelSource.url(Uri.parse(modelPath));

      await _engine?.loadModelSource(
        source,
        modelParams: modelParams ?? const ModelParams(),
      );
      _session = ChatSession(_engine!);
      _isInitialized = true;
      AppLog.i('LlmPlaygroundRemoteDataSourceImpl initialized: $modelPath');
    } catch (e, stackTrace) {
      _isInitialized = false;
      AppLog.e('Failed to initialize LlmPlaygroundRemoteDataSourceImpl: $e',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  void resetSession() {
    if (_engine != null && _isInitialized) {
      _session = ChatSession(_engine!);
      AppLog.i('LlmPlaygroundRemoteDataSourceImpl session reset.');
    }
  }

  @override
  Stream<LlamaCompletionChunk>? createChatStream(
    String prompt, {
    GenerationParams? generationParams,
  }) {
    if (!_isInitialized || _session == null) {
      AppLog.e('LlmPlaygroundRemoteDataSourceImpl is not initialized.');
      return null;
    }
    try {
      final message = LlamaTextContent(prompt);
      return _session?.create([message], params: generationParams);
    } catch (e, stackTrace) {
      AppLog.e('Error in LlmPlaygroundRemoteDataSourceImpl chat stream: $e',
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
      AppLog.i('LlmPlaygroundRemoteDataSourceImpl disposed.');
    } catch (e, stackTrace) {
      AppLog.e('Error disposing LlmPlaygroundRemoteDataSourceImpl: $e',
          error: e, stackTrace: stackTrace);
    }
  }
}
