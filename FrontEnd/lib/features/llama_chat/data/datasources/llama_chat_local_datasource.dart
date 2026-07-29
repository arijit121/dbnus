import 'package:llamadart/llamadart.dart';
import '../../presentation/utils/llama_service.dart';

abstract class LlamaChatLocalDataSource {
  bool get isInitialized;
  Future<void> initializeModel({required String modelPath, ModelParams? modelParams});
  Stream<LlamaCompletionChunk>? createChatStream(String prompt, {GenerationParams? generationParams});
  Future<String?> generateResponse(String prompt, {GenerationParams? generationParams});
  Future<void> dispose();
}

class LlamaChatLocalDataSourceImpl implements LlamaChatLocalDataSource {
  final LlamaService _llamaService;

  LlamaChatLocalDataSourceImpl({LlamaService? llamaService})
      : _llamaService = llamaService ?? LlamaService();

  @override
  bool get isInitialized => _llamaService.isInitialized;

  @override
  Future<void> initializeModel({required String modelPath, ModelParams? modelParams}) {
    return _llamaService.initialize(modelPath: modelPath, modelParams: modelParams);
  }

  @override
  Stream<LlamaCompletionChunk>? createChatStream(String prompt, {GenerationParams? generationParams}) {
    return _llamaService.createChatStream(prompt, generationParams: generationParams);
  }

  @override
  Future<String?> generateResponse(String prompt, {GenerationParams? generationParams}) {
    return _llamaService.generateResponse(prompt, generationParams: generationParams);
  }

  @override
  Future<void> dispose() {
    return _llamaService.dispose();
  }
}
