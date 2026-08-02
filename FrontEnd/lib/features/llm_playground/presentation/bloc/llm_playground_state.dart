import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/playground_chat_message.dart';
import '../../domain/entities/playground_chat_session.dart';
import '../../domain/entities/playground_tool.dart';

enum LlmPlaygroundStatus { initial, initializing, initialized, error }

class LlmPlaygroundState extends Equatable {
  final LlmPlaygroundStatus status;
  final List<PlaygroundChatSession> sessions;
  final String? activeSessionId;
  final PlaygroundTool selectedTool;
  final String systemPrompt;
  final String modelPath;
  final String? statusMessage;
  final String? errorMessage;
  final bool isGenerating;

  LlmPlaygroundState({
    this.status = LlmPlaygroundStatus.initial,
    this.sessions = const [],
    this.activeSessionId,
    PlaygroundTool? selectedTool,
    this.systemPrompt = 'You are an intelligent, helpful AI assistant running locally.',
    String? modelPath,
    this.statusMessage,
    this.errorMessage,
    this.isGenerating = false,
  })  : selectedTool = selectedTool ?? PlaygroundTool.availableTools.first,
        modelPath = modelPath ??
            (kIsWeb
                ? 'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf'
                : 'assets/models/ai/model.gguf');

  bool get isInitializing => status == LlmPlaygroundStatus.initializing;
  bool get isInitialized => status == LlmPlaygroundStatus.initialized;

  PlaygroundChatSession? get activeSession {
    if (activeSessionId == null) return null;
    try {
      return sessions.firstWhere((s) => s.id == activeSessionId);
    } catch (_) {
      return null;
    }
  }

  List<PlaygroundChatMessage> get messages => activeSession?.messages ?? const [];

  LlmPlaygroundState copyWith({
    LlmPlaygroundStatus? status,
    List<PlaygroundChatSession>? sessions,
    String? activeSessionId,
    PlaygroundTool? selectedTool,
    String? systemPrompt,
    String? modelPath,
    String? statusMessage,
    String? errorMessage,
    bool? isGenerating,
  }) {
    return LlmPlaygroundState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      activeSessionId: activeSessionId ?? this.activeSessionId,
      selectedTool: selectedTool ?? this.selectedTool,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      modelPath: modelPath ?? this.modelPath,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sessions,
        activeSessionId,
        selectedTool,
        systemPrompt,
        modelPath,
        statusMessage,
        errorMessage,
        isGenerating,
      ];
}
