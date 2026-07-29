import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../navigation/custom_router/custom_route.dart';
import '../../data/datasources/llama_chat_local_datasource.dart';
import '../../data/repositories/llama_chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/llama_chat_repository.dart';
import '../../domain/usecases/llama_chat_usecases.dart';

import '../widgets/model_config_card.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/empty_chat_state.dart';
import '../widgets/chat_input_bar.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';

class LlamaChatPage extends StatefulWidget {
  const LlamaChatPage({super.key});

  @override
  State<LlamaChatPage> createState() => _LlamaChatPageState();
}

class _LlamaChatPageState extends State<LlamaChatPage> {
  late final LlamaChatRepository _repository;
  late final InitializeLlamaModelUseCase _initializeUseCase;
  late final SendChatPromptUseCase _sendPromptUseCase;
  late final DisposeLlamaUseCase _disposeUseCase;

  final TextEditingController _modelPathController = TextEditingController(
    text: 'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf',
  );
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [];
  bool _isInitializing = false;
  bool _isGenerating = false;
  String? _statusMessage;

  final List<String> _quickPrompts = [
    'Explain quantum computing in simple terms',
    'Write a Flutter widget for a gradient button',
    'How does local LLM inference work in LlamaDart?',
    'Give me 3 healthy breakfast ideas',
  ];

  @override
  void initState() {
    super.initState();
    final localDataSource = LlamaChatLocalDataSourceImpl();
    _repository = LlamaChatRepositoryImpl(localDataSource: localDataSource);
    _initializeUseCase = InitializeLlamaModelUseCase(_repository);
    _sendPromptUseCase = SendChatPromptUseCase(_repository);
    _disposeUseCase = DisposeLlamaUseCase(_repository);
  }

  @override
  void dispose() {
    _modelPathController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _disposeUseCase();
    super.dispose();
  }

  Future<void> _initializeModel() async {
    final path = _modelPathController.text.trim();
    if (path.isEmpty) return;

    setState(() {
      _isInitializing = true;
      _statusMessage = 'Initializing Llama engine...';
    });

    try {
      await _initializeUseCase(modelPath: path);
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _statusMessage = 'Model loaded & ready!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _statusMessage = 'Failed to load model: $e';
        });
      }
    }
  }

  Future<void> _sendMessage([String? customText]) async {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty || _isGenerating) return;

    if (!_repository.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please initialize the model first.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isGenerating = true;
    });

    _scrollToBottom();

    final assistantMsgIndex = _messages.length;
    setState(() {
      _messages.add(ChatMessage(
        text: '',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    try {
      final stream = _sendPromptUseCase(text);
      if (stream != null) {
        final responseBuffer = StringBuffer();
        await for (final chunk in stream) {
          if (chunk.choices.isNotEmpty) {
            final deltaText = chunk.choices.first.delta.content;
            if (deltaText != null) {
              responseBuffer.write(deltaText);
              if (mounted) {
                setState(() {
                  _messages[assistantMsgIndex] = ChatMessage(
                    text: responseBuffer.toString(),
                    isUser: false,
                    timestamp: DateTime.now(),
                  );
                });
                _scrollToBottom();
              }
            }
          }
        }
      }
    } catch (e) {
      AppLog.e('Generation error: $e');
      if (mounted) {
        setState(() {
          _messages[assistantMsgIndex] = ChatMessage(
            text: 'Error generating response: $e',
            isUser: false,
            timestamp: DateTime.now(),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => CustomRoute.back(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigoAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LlamaDart AI Assistant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _repository.isInitialized ? 'Model Active' : 'Model Standby',
                  style: TextStyle(
                    fontSize: 12,
                    color: _repository.isInitialized ? Colors.greenAccent : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ModelConfigCard(
              controller: _modelPathController,
              isInitializing: _isInitializing,
              isInitialized: _repository.isInitialized,
              statusMessage: _statusMessage,
              onInitialize: _initializeModel,
            ),
            Expanded(
              child: _messages.isEmpty
                  ? const EmptyChatState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return ChatBubble(message: msg);
                      },
                    ),
            ),
            if (_messages.isEmpty && !_isGenerating)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickPrompts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final prompt = _quickPrompts[index];
                    return ActionChip(
                      label: Text(prompt, style: const TextStyle(fontSize: 12)),
                      avatar: const Icon(Icons.auto_awesome, size: 14),
                      onPressed: () => _sendMessage(prompt),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            ChatInputBar(
              controller: _messageController,
              isGenerating: _isGenerating,
              isInitialized: _repository.isInitialized,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
