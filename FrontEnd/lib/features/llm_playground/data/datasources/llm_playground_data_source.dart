import 'package:llamadart/llamadart.dart';

abstract class LlmPlaygroundDataSource {
  Future<void> initialize({
    required String modelPath,
    LlamaBackend? backend,
    ModelParams? modelParams,
  });
  void resetSession();
  Stream<LlamaCompletionChunk>? createChatStream(
    String prompt, {
    GenerationParams? generationParams,
  });
  Future<void> dispose();
  bool get isInitialized;
}
