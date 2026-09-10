import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:llamadart/llamadart.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/llama_chat_usecases.dart';
import 'llama_chat_event.dart';
import 'llama_chat_state.dart';

class LlamaChatBloc extends Bloc<LlamaChatEvent, LlamaChatState> {
  final InitializeLlamaModelUseCase initializeUseCase;
  final SendChatPromptUseCase sendPromptUseCase;
  final DisposeLlamaUseCase disposeUseCase;
  StreamSubscription<LlamaCompletionChunk>? _streamSubscription;

  LlamaChatBloc({
    required this.initializeUseCase,
    required this.sendPromptUseCase,
    required this.disposeUseCase,
  }) : super(const LlamaChatState()) {
    on<InitializeLlamaModelEvent>(_onInitializeModel);
    on<SendLlamaPromptEvent>(_onSendPrompt);
    on<StreamChunkReceivedEvent>(_onStreamChunkReceived);
    on<GenerationCompletedEvent>(_onGenerationCompleted);
    on<ResetLlamaChatEvent>(_onResetChat);
  }

  Future<void> _onInitializeModel(
    InitializeLlamaModelEvent event,
    Emitter<LlamaChatState> emit,
  ) async {
    emit(state.copyWith(
      status: LlamaChatStatus.initializing,
      modelPath: event.modelPath,
      statusMessage: 'Loading weights...',
      errorMessage: null,
    ));

    try {
      await initializeUseCase(modelPath: event.modelPath);
      emit(state.copyWith(
        status: LlamaChatStatus.initialized,
        statusMessage: 'Model Initialized',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LlamaChatStatus.error,
        statusMessage: 'Failed',
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSendPrompt(
    SendLlamaPromptEvent event,
    Emitter<LlamaChatState> emit,
  ) async {
    if (!state.isInitialized || event.prompt.trim().isEmpty) return;

    final now = DateTime.now();
    final userMsg = ChatMessage(text: event.prompt, isUser: true, timestamp: now);
    final botMsg = ChatMessage(text: '', isUser: false, timestamp: now);
    final updatedMessages = List<ChatMessage>.from(state.messages)..addAll([userMsg, botMsg]);

    emit(state.copyWith(
      status: LlamaChatStatus.generating,
      messages: updatedMessages,
    ));

    await _streamSubscription?.cancel();
    final stream = sendPromptUseCase(event.prompt);
    if (stream == null) {
      emit(state.copyWith(
        status: LlamaChatStatus.error,
        errorMessage: 'Failed to create streaming completion session.',
      ));
      return;
    }

    _streamSubscription = stream.listen(
      (chunk) {
        if (chunk.choices.isNotEmpty) {
          final content = chunk.choices.first.delta.content;
          if (content != null && content.isNotEmpty) {
            add(StreamChunkReceivedEvent(chunk: content));
          }
        }
      },
      onError: (err) {
        add(StreamChunkReceivedEvent(chunk: '\n[Error: $err]'));
        add(const GenerationCompletedEvent());
      },
      onDone: () {
        add(const GenerationCompletedEvent());
      },
    );
  }

  void _onStreamChunkReceived(
    StreamChunkReceivedEvent event,
    Emitter<LlamaChatState> emit,
  ) {
    if (state.messages.isEmpty) return;

    final updated = List<ChatMessage>.from(state.messages);
    final lastIndex = updated.length - 1;
    final last = updated[lastIndex];

    updated[lastIndex] = ChatMessage(
      text: last.text + event.chunk,
      isUser: last.isUser,
      timestamp: last.timestamp,
    );

    emit(state.copyWith(
      status: LlamaChatStatus.generating,
      messages: updated,
    ));
  }

  void _onGenerationCompleted(
    GenerationCompletedEvent event,
    Emitter<LlamaChatState> emit,
  ) {
    emit(state.copyWith(
      status: LlamaChatStatus.initialized,
    ));
  }

  void _onResetChat(
    ResetLlamaChatEvent event,
    Emitter<LlamaChatState> emit,
  ) {
    _streamSubscription?.cancel();
    emit(state.copyWith(
      messages: const [],
      status: state.isInitialized ? LlamaChatStatus.initialized : LlamaChatStatus.initial,
    ));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    disposeUseCase();
    return super.close();
  }
}
