import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/playground_tool.dart';
import '../bloc/llm_playground_bloc.dart';
import '../bloc/llm_playground_event.dart';
import '../bloc/llm_playground_state.dart';

class PlaygroundChatHistoryDrawer extends StatelessWidget {
  const PlaygroundChatHistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: SafeArea(
        child: BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & New Chat Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.forum_rounded, color: Colors.indigoAccent, size: 22),
                      const SizedBox(width: 10),
                      const Text(
                        'Chat History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<LlmPlaygroundBloc>().add(const CreateNewChatEvent());
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.add_rounded, size: 20, color: Colors.indigoAccent),
                    label: const Text(
                      'New Chat',
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.indigoAccent, width: 1.5),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : Colors.grey[200]),

                // Chat History List
                Expanded(
                  child: state.sessions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 40,
                                color: isDark ? Colors.white24 : Colors.grey[300],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No previous chats',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.white38 : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          itemCount: state.sessions.length,
                          itemBuilder: (context, index) {
                            final session = state.sessions[index];
                            final isSelected = session.id == state.activeSessionId;

                            PlaygroundTool? tool;
                            try {
                              tool = PlaygroundTool.availableTools.firstWhere((t) => t.id == session.selectedToolId);
                            } catch (_) {}

                            final timeStr = DateFormat('MMM d, h:mm a').format(session.updatedAt);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ListTile(
                                dense: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor: isSelected
                                    ? Colors.indigoAccent.withValues(alpha: isDark ? 0.2 : 0.1)
                                    : Colors.transparent,
                                leading: Icon(
                                  tool?.icon ?? Icons.chat_bubble_outline_rounded,
                                  size: 18,
                                  color: isSelected
                                      ? Colors.indigoAccent
                                      : (isDark ? Colors.white60 : Colors.grey[600]),
                                ),
                                title: Text(
                                  session.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.indigoAccent
                                        : (isDark ? Colors.white : Colors.black87),
                                  ),
                                ),
                                subtitle: Text(
                                  '$timeStr • ${session.messages.length} msgs',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? Colors.white38 : Colors.grey[500],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 16,
                                    color: isDark ? Colors.white38 : Colors.grey[400],
                                  ),
                                  tooltip: 'Delete Chat',
                                  onPressed: () {
                                    context.read<LlmPlaygroundBloc>().add(DeleteChatSessionEvent(session.id));
                                  },
                                ),
                                onTap: () {
                                  context.read<LlmPlaygroundBloc>().add(SelectChatSessionEvent(session.id));
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                ),

                // Clear History Option
                if (state.sessions.isNotEmpty) ...[
                  Divider(height: 1, color: isDark ? const Color(0xFF1E293B) : Colors.grey[200]),
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.delete_sweep_rounded, size: 18, color: Colors.redAccent),
                    title: const Text(
                      'Clear Chat History',
                      style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      context.read<LlmPlaygroundBloc>().add(const ClearAllHistoryEvent());
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
