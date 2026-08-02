import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../navigation/custom_router/custom_route.dart';
import '../../domain/entities/playground_tool.dart';
import '../bloc/llm_playground_bloc.dart';
import '../bloc/llm_playground_event.dart';
import '../bloc/llm_playground_state.dart';
import '../widgets/playground_chat_history_drawer.dart';
import '../widgets/playground_message_bubble.dart';

class LlmPlaygroundPage extends StatelessWidget {
  const LlmPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LlmPlaygroundBloc()..add(const InitializeModelEvent()),
      child: const _LlmPlaygroundView(),
    );
  }
}

class _LlmPlaygroundView extends StatefulWidget {
  const _LlmPlaygroundView();

  @override
  State<_LlmPlaygroundView> createState() => _LlmPlaygroundViewState();
}

class _LlmPlaygroundViewState extends State<_LlmPlaygroundView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
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

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context
        .read<LlmPlaygroundBloc>()
        .add(SendPlaygroundMessageEvent(text: text));
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      drawer: const PlaygroundChatHistoryDrawer(),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => CustomRoute.back(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigoAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.indigoAccent, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
                    builder: (context, state) {
                      final title =
                          state.activeSession?.title ?? 'LLM AI Assistant';
                      return Text(
                        title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
                    builder: (context, state) {
                      Color statusColor;
                      String statusText;
                      if (state.isInitializing) {
                        statusColor = Colors.orangeAccent;
                        statusText = 'Initializing Model...';
                      } else if (state.isInitialized) {
                        statusColor = Colors.green;
                        statusText = 'Model Ready';
                      } else if (state.status == LlmPlaygroundStatus.error) {
                        statusColor = Colors.redAccent;
                        statusText = 'Initialization Failed';
                      } else {
                        statusColor = Colors.grey;
                        statusText = 'Uninitialized';
                      }

                      return Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                                fontSize: 11,
                                color: statusColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.indigoAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.indigoAccent, size: 20),
              tooltip: 'Start New Chat',
              onPressed: () {
                context.read<LlmPlaygroundBloc>().add(const CreateNewChatEvent());
              },
            ),
          ),
          Builder(
            builder: (ctx) => Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.forum_rounded, color: Colors.indigoAccent, size: 20),
                tooltip: 'Chat History',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<LlmPlaygroundBloc, LlmPlaygroundState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state.messages.isNotEmpty) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (state.isInitializing)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: Color(0xFFE2E8F0),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
                  ),

                // Chat Messages or Empty Welcome State
                Expanded(
                  child: state.messages.isEmpty
                      ? _buildEmptyWelcomeState(context, state)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return PlaygroundMessageBubble(
                              message: state.messages[index],
                            );
                          },
                        ),
                ),

                // Bottom Bar: Tool Selector & Input Bar
                _buildBottomInputArea(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyWelcomeState(
      BuildContext context, LlmPlaygroundState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigoAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 40,
              color: Colors.indigoAccent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How can I help you today?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 24),

          // Tools Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
            ),
            itemCount: PlaygroundTool.availableTools.length,
            itemBuilder: (context, index) {
              final tool = PlaygroundTool.availableTools[index];
              final isSelected = tool.id == state.selectedTool.id;

              return InkWell(
                onTap: () {
                  context.read<LlmPlaygroundBloc>().add(SelectToolEvent(tool));
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Colors.indigoAccent
                          : (isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(tool.icon, color: Colors.indigoAccent, size: 20),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              tool.title,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded,
                                color: Colors.indigoAccent, size: 16),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tool.description,
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputArea(BuildContext context, LlmPlaygroundState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentTool = state.selectedTool;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Horizontal Tool Chips Toolbar
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: PlaygroundTool.availableTools.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final tool = PlaygroundTool.availableTools[index];
                final isSelected = tool.id == currentTool.id;
                return ChoiceChip(
                  avatar: Icon(
                    tool.icon,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.indigoAccent,
                  ),
                  label: Text(tool.title),
                  selected: isSelected,
                  selectedColor: Colors.indigoAccent,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      context
                          .read<LlmPlaygroundBloc>()
                          .add(SelectToolEvent(tool));
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          // Input Text Field & Action Button
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 4,
                    enabled: state.isInitialized && !state.isGenerating,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: !state.isInitialized
                          ? (state.isInitializing
                              ? 'Loading AI Model...'
                              : 'Model Not Loaded')
                          : 'Ask or enter text for ${currentTool.title}...',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),

                // Send or Stop Generation Button
                if (state.isGenerating)
                  IconButton.filled(
                    onPressed: () {
                      context
                          .read<LlmPlaygroundBloc>()
                          .add(const StopGenerationEvent());
                    },
                    icon: const Icon(Icons.stop_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  )
                else
                  IconButton.filled(
                    onPressed: state.isInitialized ? _sendMessage : null,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
