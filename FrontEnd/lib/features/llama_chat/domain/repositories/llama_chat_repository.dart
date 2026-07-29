import 'package:llamadart/llamadart.dart';

abstract class LlamaChatRepository {
  bool get isInitialized;
  Future<void> initializeModel({required String modelPath, ModelParams? modelParams});
  Stream<LlamaCompletionChunk>? createChatStream(String prompt, {GenerationParams? generationParams});
  Future<String?> generateResponse(String prompt, {GenerationParams? generationParams});
  Future<void> dispose();
}
