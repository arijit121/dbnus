import 'package:llamadart/llamadart.dart';

abstract class PlaygroundRepository {
  Future<void> initializeModel({
    required String modelPath,
    LlamaBackend? backend,
    ModelParams? modelParams,
  });
  void resetSession();
  Stream<LlamaCompletionChunk>? createChatStream(String prompt,
      {GenerationParams? generationParams});
  Future<void> dispose();
  bool get isInitialized;
}
