import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../navigation/custom_router/custom_route.dart';
import '../../data/datasources/llama_chat_local_datasource.dart';
import '../../data/repositories/llama_chat_repository_impl.dart';
import '../../domain/usecases/llama_chat_usecases.dart';

import '../bloc/llama_chat_bloc.dart';
import '../bloc/llama_chat_event.dart';
import '../bloc/llama_chat_state.dart';

import '../widgets/model_config_card.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/empty_chat_state.dart';
import '../widgets/chat_input_bar.dart';

class LlamaChatPage extends StatelessWidget {
  const LlamaChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDataSource = LlamaChatLocalDataSourceImpl();
    final repository = LlamaChatRepositoryImpl(localDataSource: localDataSource);

    return BlocProvider<LlamaChatBloc>(
      create: (context) => LlamaChatBloc(
        initializeUseCase: InitializeLlamaModelUseCase(repository),
        sendPromptUseCase: SendChatPromptUseCase(repository),
        disposeUseCase: DisposeLlamaUseCase(repository),
      ),
      child: const _LlamaChatView(),
    );
  }
}

class _LlamaChatView extends StatefulWidget {
  const _LlamaChatView();

  @override
  State<_LlamaChatView> createState() => _LlamaChatViewState();
}

class _LlamaChatViewState extends State<_LlamaChatView> {
  final TextEditingController _modelPathController = TextEditingController(
    text:
        'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf',
  );
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickPrompts = [
    'Explain quantum computing in simple terms',
    'Write a Flutter widget for a gradient button',
    'How does local LLM inference work in LlamaDart?',
    'Give me 3 healthy breakfast ideas',
  ];

  @override
  void dispose() {
    _modelPathController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _sendMessage(BuildContext context, [String? customText]) {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    context.read<LlamaChatBloc>().add(SendLlamaPromptEvent(prompt: text));
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<LlamaChatBloc, LlamaChatState>(
      listener: (context, state) {
        _scrollToBottom();
        if (state.errorMessage != null && state.status == LlamaChatStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
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
                      state.isInitialized ? 'Model Active' : 'Model Standby',
                      style: TextStyle(
                        fontSize: 12,
                        color: state.isInitialized ? Colors.greenAccent : Colors.grey,
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
                  isInitializing: state.isInitializing,
                  isInitialized: state.isInitialized,
                  statusMessage: state.statusMessage,
                  onInitialize: () {
                    context.read<LlamaChatBloc>().add(
                          InitializeLlamaModelEvent(
                            modelPath: _modelPathController.text.trim(),
                          ),
                        );
                  },
                ),
                Expanded(
                  child: state.messages.isEmpty
                      ? const EmptyChatState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final msg = state.messages[index];
                            return ChatBubble(message: msg);
                          },
                        ),
                ),
                if (state.messages.isEmpty && !state.isGenerating)
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
                          onPressed: () => _sendMessage(context, prompt),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 8),
                ChatInputBar(
                  controller: _messageController,
                  isGenerating: state.isGenerating,
                  isInitialized: state.isInitialized,
                  onSend: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
