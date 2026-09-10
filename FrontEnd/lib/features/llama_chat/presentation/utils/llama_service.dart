import 'package:flutter/foundation.dart';
import 'package:llamadart/llamadart.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';

/// Service wrapper for llamadart 0.8.17 integration.
class LlamaService {
  LlamaEngine? _engine;
  ChatSession? _session;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initializes the Llama engine with a specified backend and loads a model file.
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

      final source = (modelPath.startsWith('http://') || modelPath.startsWith('https://'))
          ? ModelSource.url(Uri.parse(modelPath))
          : ModelSource.path(modelPath);

      await _engine?.loadModelSource(
        source,
        modelParams: modelParams ?? const ModelParams(),
      );
      _session = ChatSession(_engine!);
      _isInitialized = true;
      AppLog.i('LlamaService initialized with model: $modelPath');
    } catch (e, stackTrace) {
      _isInitialized = false;
      AppLog.e('Failed to initialize LlamaService: $e', error: e, stackTrace: stackTrace);

      if (kIsWeb && (e.toString().contains('Web bridge is unavailable') || e.toString().contains('LlamaException'))) {
        throw Exception(
          'WebGPU LLM bridge issue on Web. '
          'Web browsers require WebGPU support and dynamic bridge loading. '
          'For full native C++ local LLM execution, run on Android, iOS, Windows, macOS, or Linux.',
        );
      }
      rethrow;
    }
  }

  /// Creates a chat stream for a prompt message using [ChatSession].
  Stream<LlamaCompletionChunk>? createChatStream(String prompt, {GenerationParams? generationParams}) {
    if (!_isInitialized || _session == null) {
      AppLog.e('LlamaService is not initialized.');
      return null;
    }
    try {
      final message = LlamaTextContent(prompt);
      return _session?.create([message], params: generationParams);
    } catch (e, stackTrace) {
      AppLog.e('Error creating chat stream: $e', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Sends a text prompt and returns the full aggregated response text.
  Future<String?> generateResponse(String prompt, {GenerationParams? generationParams}) async {
    final stream = createChatStream(prompt, generationParams: generationParams);
    if (stream == null) return null;

    final buffer = StringBuffer();
    await for (final chunk in stream) {
      if (chunk.choices.isNotEmpty) {
        final text = chunk.choices.first.delta.content;
        if (text != null) {
          buffer.write(text);
        }
      }
    }
    return buffer.toString();
  }

  /// Disposes the underlying LlamaEngine and session.
  Future<void> dispose() async {
    try {
      _session = null;
      await _engine?.dispose();
      _engine = null;
      _isInitialized = false;
      AppLog.i('LlamaService disposed.');
    } catch (e, stackTrace) {
      AppLog.e('Error disposing LlamaService: $e', error: e, stackTrace: stackTrace);
    }
  }
}
