import 'package:llamadart/llamadart.dart';
import '../../domain/repositories/llama_chat_repository.dart';
import '../datasources/llama_chat_local_datasource.dart';

class LlamaChatRepositoryImpl implements LlamaChatRepository {
  final LlamaChatLocalDataSource localDataSource;

  LlamaChatRepositoryImpl({required this.localDataSource});

  @override
  bool get isInitialized => localDataSource.isInitialized;

  @override
  Future<void> initializeModel({required String modelPath, ModelParams? modelParams}) {
    return localDataSource.initializeModel(modelPath: modelPath, modelParams: modelParams);
  }

  @override
  Stream<LlamaCompletionChunk>? createChatStream(String prompt, {GenerationParams? generationParams}) {
    return localDataSource.createChatStream(prompt, generationParams: generationParams);
  }

  @override
  Future<String?> generateResponse(String prompt, {GenerationParams? generationParams}) {
    return localDataSource.generateResponse(prompt, generationParams: generationParams);
  }

  @override
  Future<void> dispose() {
    return localDataSource.dispose();
  }
}
