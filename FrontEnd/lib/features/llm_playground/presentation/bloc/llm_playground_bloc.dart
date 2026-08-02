import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/playground_chat_message.dart';
import '../../domain/entities/playground_chat_session.dart';
import '../../domain/entities/playground_tool.dart';
import '../../domain/repositories/playground_repository.dart';
import '../../data/repositories/playground_repository_impl.dart';
import 'llm_playground_event.dart';
import 'llm_playground_state.dart';

class LlmPlaygroundBloc extends Bloc<LlmPlaygroundEvent, LlmPlaygroundState> {
  final PlaygroundRepository _repository;
  StreamSubscription? _streamSubscription;
  final Uuid _uuid = const Uuid();

  LlmPlaygroundBloc({PlaygroundRepository? repository})
      : _repository = repository ?? PlaygroundRepositoryImpl(),
        super(LlmPlaygroundState()) {
    on<InitializeModelEvent>(_onInitializeModel);
    on<SelectToolEvent>(_onSelectTool);
    on<UpdateSystemPromptEvent>(_onUpdateSystemPrompt);
    on<SendPlaygroundMessageEvent>(_onSendMessage);
    on<StreamChunkReceivedEvent>(_onStreamChunkReceived);
    on<GenerationCompletedEvent>(_onGenerationCompleted);
    on<StopGenerationEvent>(_onStopGeneration);
    on<ClearChatEvent>(_onClearChat);
    on<CreateNewChatEvent>(_onCreateNewChat);
    on<SelectChatSessionEvent>(_onSelectChatSession);
    on<DeleteChatSessionEvent>(_onDeleteChatSession);
    on<ClearAllHistoryEvent>(_onClearAllHistory);
  }

  PlaygroundRepository get repository => _repository;

  Future<void> _onInitializeModel(
    InitializeModelEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) async {
    final targetPath = event.modelPath ?? state.modelPath;

    emit(state.copyWith(
      status: LlmPlaygroundStatus.initializing,
      modelPath: targetPath,
      statusMessage: 'Loading model weights...',
      errorMessage: null,
    ));

    try {
      await _repository.initializeModel(modelPath: targetPath);
      emit(state.copyWith(
        status: LlmPlaygroundStatus.initialized,
        statusMessage: 'Model Ready',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LlmPlaygroundStatus.error,
        statusMessage: 'Initialization Failed',
        errorMessage: e.toString(),
      ));
    }
  }

  void _onCreateNewChat(
    CreateNewChatEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    _streamSubscription?.cancel();
    _repository.resetSession();
    final tool = event.tool ?? state.selectedTool;

    // Check if an empty chat session already exists
    PlaygroundChatSession? existingEmpty;
    try {
      existingEmpty = state.sessions.firstWhere((s) => s.messages.isEmpty);
    } catch (_) {
      existingEmpty = null;
    }

    if (existingEmpty != null) {
      final updatedSessions = state.sessions.map((s) {
        if (s.id == existingEmpty!.id) {
          return s.copyWith(selectedToolId: tool.id, updatedAt: DateTime.now());
        }
        return s;
      }).toList();

      emit(state.copyWith(
        sessions: updatedSessions,
        activeSessionId: existingEmpty.id,
        selectedTool: tool,
        isGenerating: false,
      ));
      return;
    }

    final now = DateTime.now();
    final newSession = PlaygroundChatSession(
      id: _uuid.v4(),
      title: 'New Chat',
      messages: const [],
      selectedToolId: tool.id,
      createdAt: now,
      updatedAt: now,
    );

    final updatedSessions = List<PlaygroundChatSession>.from(state.sessions)..insert(0, newSession);

    emit(state.copyWith(
      sessions: updatedSessions,
      activeSessionId: newSession.id,
      selectedTool: tool,
      isGenerating: false,
    ));
  }

  void _onSelectChatSession(
    SelectChatSessionEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    try {
      final session = state.sessions.firstWhere((s) => s.id == event.sessionId);
      final tool = PlaygroundTool.availableTools.firstWhere(
        (t) => t.id == session.selectedToolId,
        orElse: () => PlaygroundTool.availableTools.first,
      );

      _streamSubscription?.cancel();
      _repository.resetSession();

      emit(state.copyWith(
        activeSessionId: session.id,
        selectedTool: tool,
      ));
    } catch (_) {}
  }

  void _onDeleteChatSession(
    DeleteChatSessionEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    final updatedSessions = state.sessions.where((s) => s.id != event.sessionId).toList();

    String? newActiveId = state.activeSessionId;
    if (state.activeSessionId == event.sessionId) {
      _streamSubscription?.cancel();
      _repository.resetSession();
      newActiveId = updatedSessions.isNotEmpty ? updatedSessions.first.id : null;
    }

    emit(state.copyWith(
      sessions: updatedSessions,
      activeSessionId: newActiveId,
      isGenerating: state.activeSessionId == event.sessionId ? false : state.isGenerating,
    ));
  }

  void _onClearAllHistory(
    ClearAllHistoryEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    _streamSubscription?.cancel();
    _repository.resetSession();
    emit(state.copyWith(
      sessions: const [],
      activeSessionId: null,
      isGenerating: false,
    ));
  }

  void _onSelectTool(
    SelectToolEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    if (state.selectedTool.id != event.tool.id) {
      _streamSubscription?.cancel();
      _repository.resetSession();
    }

    emit(state.copyWith(selectedTool: event.tool));

    if (state.activeSessionId != null) {
      final sessions = state.sessions.map((s) {
        if (s.id == state.activeSessionId) {
          return s.copyWith(selectedToolId: event.tool.id);
        }
        return s;
      }).toList();
      emit(state.copyWith(sessions: sessions));
    }
  }

  void _onUpdateSystemPrompt(
    UpdateSystemPromptEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    emit(state.copyWith(systemPrompt: event.systemPrompt));
  }

  Future<void> _onSendMessage(
    SendPlaygroundMessageEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) async {
    final rawText = event.text.trim();
    if (rawText.isEmpty || !_repository.isInitialized || state.isGenerating) return;

    // Ensure we have an active session
    PlaygroundChatSession session;
    List<PlaygroundChatSession> sessions = List<PlaygroundChatSession>.from(state.sessions);

    if (state.activeSession == null) {
      final now = DateTime.now();
      session = PlaygroundChatSession(
        id: _uuid.v4(),
        title: rawText.length > 25 ? '${rawText.substring(0, 25)}...' : rawText,
        messages: const [],
        selectedToolId: state.selectedTool.id,
        createdAt: now,
        updatedAt: now,
      );
      sessions.insert(0, session);
      _repository.resetSession();
    } else {
      session = state.activeSession!;
      if (session.messages.isEmpty) {
        final title = rawText.length > 25 ? '${rawText.substring(0, 25)}...' : rawText;
        session = session.copyWith(title: title);
        _repository.resetSession();
      } else {
        // If switching tool mid-chat, reset LLM session context so tool prefixes don't collide
        final lastMsgTool = session.messages.last.toolUsed;
        if (lastMsgTool != null && lastMsgTool != state.selectedTool.id) {
          _repository.resetSession();
        }
      }
    }

    final tool = state.selectedTool;
    String fullPrompt = '';

    if (tool.id == PlaygroundToolId.promptStudio) {
      final sys = state.systemPrompt.trim();
      fullPrompt = sys.isNotEmpty ? 'System: $sys\n\nUser: $rawText' : rawText;
    } else if (tool.promptPrefix.isNotEmpty) {
      fullPrompt = '${tool.promptPrefix}$rawText';
    } else {
      fullPrompt = rawText;
    }

    final now = DateTime.now();
    final userMsg = PlaygroundChatMessage(
      id: _uuid.v4(),
      text: rawText,
      isUser: true,
      timestamp: now,
      toolUsed: tool.id,
    );

    final botMsg = PlaygroundChatMessage(
      id: _uuid.v4(),
      text: '',
      isUser: false,
      timestamp: now,
      toolUsed: tool.id,
      isStreaming: true,
    );

    final updatedMessages = List<PlaygroundChatMessage>.from(session.messages)..addAll([userMsg, botMsg]);
    final updatedSession = session.copyWith(
      messages: updatedMessages,
      updatedAt: now,
    );

    final sessionIndex = sessions.indexWhere((s) => s.id == updatedSession.id);
    if (sessionIndex != -1) {
      sessions[sessionIndex] = updatedSession;
    } else {
      sessions.insert(0, updatedSession);
    }

    emit(state.copyWith(
      isGenerating: true,
      sessions: sessions,
      activeSessionId: updatedSession.id,
    ));

    await _streamSubscription?.cancel();
    final stream = _repository.createChatStream(fullPrompt);
    if (stream == null) {
      emit(state.copyWith(
        isGenerating: false,
        errorMessage: 'Failed to create AI generation stream.',
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
    Emitter<LlmPlaygroundState> emit,
  ) {
    if (state.activeSession == null || state.activeSession!.messages.isEmpty) return;

    final session = state.activeSession!;
    final updated = List<PlaygroundChatMessage>.from(session.messages);
    final lastIndex = updated.length - 1;
    final last = updated[lastIndex];

    if (!last.isUser) {
      updated[lastIndex] = last.copyWith(
        text: last.text + event.chunk,
        isStreaming: true,
      );

      final updatedSession = session.copyWith(messages: updated);
      final sessions = state.sessions.map((s) => s.id == updatedSession.id ? updatedSession : s).toList();

      emit(state.copyWith(
        isGenerating: true,
        sessions: sessions,
      ));
    }
  }

  void _onGenerationCompleted(
    GenerationCompletedEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    if (state.activeSession != null) {
      final session = state.activeSession!;
      final updated = List<PlaygroundChatMessage>.from(session.messages);
      if (updated.isNotEmpty) {
        final lastIndex = updated.length - 1;
        final last = updated[lastIndex];
        if (!last.isUser) {
          updated[lastIndex] = last.copyWith(isStreaming: false);
        }
      }

      final updatedSession = session.copyWith(messages: updated);
      final sessions = state.sessions.map((s) => s.id == updatedSession.id ? updatedSession : s).toList();

      emit(state.copyWith(
        isGenerating: false,
        sessions: sessions,
      ));
    } else {
      emit(state.copyWith(isGenerating: false));
    }
  }

  void _onStopGeneration(
    StopGenerationEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    _streamSubscription?.cancel();
    _repository.resetSession();
    add(const GenerationCompletedEvent());
  }

  void _onClearChat(
    ClearChatEvent event,
    Emitter<LlmPlaygroundState> emit,
  ) {
    _streamSubscription?.cancel();
    _repository.resetSession();
    if (state.activeSessionId != null) {
      add(DeleteChatSessionEvent(state.activeSessionId!));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _repository.dispose();
    return super.close();
  }
}
