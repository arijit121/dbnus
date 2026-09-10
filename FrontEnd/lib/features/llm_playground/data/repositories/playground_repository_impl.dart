import 'package:llamadart/llamadart.dart';
import '../../domain/repositories/playground_repository.dart';
import '../datasources/llm_playground_data_source.dart';
import '../datasources/llm_playground_local_data_source.dart';
import '../datasources/llm_playground_remote_data_source.dart';

class PlaygroundRepositoryImpl implements PlaygroundRepository {
  final LlmPlaygroundDataSource localDataSource;
  final LlmPlaygroundDataSource remoteDataSource;
  LlmPlaygroundDataSource? _activeDataSource;

  PlaygroundRepositoryImpl({
    LlmPlaygroundDataSource? localDataSource,
    LlmPlaygroundDataSource? remoteDataSource,
  })  : localDataSource = localDataSource ?? LlmPlaygroundLocalDataSourceImpl(),
        remoteDataSource =
            remoteDataSource ?? LlmPlaygroundRemoteDataSourceImpl();

  @override
  Future<void> initializeModel({
    required String modelPath,
    LlamaBackend? backend,
    ModelParams? modelParams,
  }) async {
    if (_activeDataSource != null && _activeDataSource!.isInitialized) {
      await _activeDataSource!.dispose();
    }

    final isRemote =
        modelPath.startsWith('http://') || modelPath.startsWith('https://');
    _activeDataSource = isRemote ? remoteDataSource : localDataSource;

    await _activeDataSource!.initialize(
      modelPath: modelPath,
      backend: backend,
      modelParams: modelParams,
    );
  }

  @override
  void resetSession() {
    _activeDataSource?.resetSession();
  }

  @override
  Stream<LlamaCompletionChunk>? createChatStream(
    String prompt, {
    GenerationParams? generationParams,
  }) {
    return _activeDataSource?.createChatStream(prompt,
        generationParams: generationParams);
  }

  @override
  Future<void> dispose() async {
    await _activeDataSource?.dispose();
    _activeDataSource = null;
  }

  @override
  bool get isInitialized => _activeDataSource?.isInitialized ?? false;
}
