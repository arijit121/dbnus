import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

enum LlamaChatStatus { initial, initializing, initialized, generating, error }

class LlamaChatState extends Equatable {
  final LlamaChatStatus status;
  final List<ChatMessage> messages;
  final String modelPath;
  final String? statusMessage;
  final String? errorMessage;

  const LlamaChatState({
    this.status = LlamaChatStatus.initial,
    this.messages = const [],
    this.modelPath =
        'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf',
    this.statusMessage,
    this.errorMessage,
  });

  bool get isInitializing => status == LlamaChatStatus.initializing;
  bool get isInitialized =>
      status == LlamaChatStatus.initialized || status == LlamaChatStatus.generating;
  bool get isGenerating => status == LlamaChatStatus.generating;

  LlamaChatState copyWith({
    LlamaChatStatus? status,
    List<ChatMessage>? messages,
    String? modelPath,
    String? statusMessage,
    String? errorMessage,
  }) {
    return LlamaChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      modelPath: modelPath ?? this.modelPath,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        modelPath,
        statusMessage,
        errorMessage,
      ];
}
