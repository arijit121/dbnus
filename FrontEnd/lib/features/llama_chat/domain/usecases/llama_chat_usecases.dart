import 'package:llamadart/llamadart.dart';
import '../repositories/llama_chat_repository.dart';

class InitializeLlamaModelUseCase {
  final LlamaChatRepository repository;
  InitializeLlamaModelUseCase(this.repository);

  Future<void> call({required String modelPath, ModelParams? modelParams}) {
    return repository.initializeModel(modelPath: modelPath, modelParams: modelParams);
  }
}

class SendChatPromptUseCase {
  final LlamaChatRepository repository;
  SendChatPromptUseCase(this.repository);

  Stream<LlamaCompletionChunk>? call(String prompt, {GenerationParams? generationParams}) {
    return repository.createChatStream(prompt, generationParams: generationParams);
  }
}

class DisposeLlamaUseCase {
  final LlamaChatRepository repository;
  DisposeLlamaUseCase(this.repository);

  Future<void> call() {
    return repository.dispose();
  }
}
