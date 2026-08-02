import 'package:equatable/equatable.dart';
import '../../domain/entities/playground_attached_file.dart';
import '../../domain/entities/playground_tool.dart';

abstract class LlmPlaygroundEvent extends Equatable {
  const LlmPlaygroundEvent();

  @override
  List<Object?> get props => [];
}

class InitializeModelEvent extends LlmPlaygroundEvent {
  final String? modelPath;

  const InitializeModelEvent({this.modelPath});

  @override
  List<Object?> get props => [modelPath];
}

class SelectToolEvent extends LlmPlaygroundEvent {
  final PlaygroundTool tool;

  const SelectToolEvent(this.tool);

  @override
  List<Object?> get props => [tool];
}

class UpdateSystemPromptEvent extends LlmPlaygroundEvent {
  final String systemPrompt;

  const UpdateSystemPromptEvent(this.systemPrompt);

  @override
  List<Object?> get props => [systemPrompt];
}

class SendPlaygroundMessageEvent extends LlmPlaygroundEvent {
  final String text;

  const SendPlaygroundMessageEvent({required this.text});

  @override
  List<Object?> get props => [text];
}

class StreamChunkReceivedEvent extends LlmPlaygroundEvent {
  final String chunk;

  const StreamChunkReceivedEvent({required this.chunk});

  @override
  List<Object?> get props => [chunk];
}

class GenerationCompletedEvent extends LlmPlaygroundEvent {
  const GenerationCompletedEvent();
}

class StopGenerationEvent extends LlmPlaygroundEvent {
  const StopGenerationEvent();
}

class ClearChatEvent extends LlmPlaygroundEvent {
  const ClearChatEvent();
}

class CreateNewChatEvent extends LlmPlaygroundEvent {
  final PlaygroundTool? tool;

  const CreateNewChatEvent({this.tool});

  @override
  List<Object?> get props => [tool];
}

class SelectChatSessionEvent extends LlmPlaygroundEvent {
  final String sessionId;

  const SelectChatSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class DeleteChatSessionEvent extends LlmPlaygroundEvent {
  final String sessionId;

  const DeleteChatSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class ClearAllHistoryEvent extends LlmPlaygroundEvent {
  const ClearAllHistoryEvent();
}

class AttachFileEvent extends LlmPlaygroundEvent {
  final PlaygroundAttachedFile file;

  const AttachFileEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class RemoveAttachedFileEvent extends LlmPlaygroundEvent {
  const RemoveAttachedFileEvent();
}

class ToggleVoiceInputEvent extends LlmPlaygroundEvent {
  final bool isListening;

  const ToggleVoiceInputEvent({required this.isListening});

  @override
  List<Object?> get props => [isListening];
}
