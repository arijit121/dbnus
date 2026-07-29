import 'package:equatable/equatable.dart';

abstract class LlamaChatEvent extends Equatable {
  const LlamaChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeLlamaModelEvent extends LlamaChatEvent {
  final String modelPath;

  const InitializeLlamaModelEvent({required this.modelPath});

  @override
  List<Object?> get props => [modelPath];
}

class SendLlamaPromptEvent extends LlamaChatEvent {
  final String prompt;

  const SendLlamaPromptEvent({required this.prompt});

  @override
  List<Object?> get props => [prompt];
}

class StreamChunkReceivedEvent extends LlamaChatEvent {
  final String chunk;

  const StreamChunkReceivedEvent({required this.chunk});

  @override
  List<Object?> get props => [chunk];
}

class GenerationCompletedEvent extends LlamaChatEvent {
  const GenerationCompletedEvent();
}

class ResetLlamaChatEvent extends LlamaChatEvent {
  const ResetLlamaChatEvent();
}
