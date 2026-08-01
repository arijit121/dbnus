import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/models/playground_tool.dart';
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
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      child: SafeArea(
        child: BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
          builder: (context, state) {
            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, color: Colors.indigoAccent, size: 22),
                          const SizedBox(width: 8),
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
                      const SizedBox(height: 12),

                      // New Chat Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<LlmPlaygroundBloc>().add(const CreateNewChatEvent());
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text(
                            'New Chat',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Sessions List
                Expanded(
                  child: state.sessions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.forum_outlined, size: 48, color: isDark ? Colors.white24 : Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text(
                                'No chat history yet',
                                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: state.sessions.length,
                          itemBuilder: (context, index) {
                            final session = state.sessions[index];
                            final isSelected = session.id == state.activeSessionId;

                            PlaygroundTool? tool;
                            try {
                              tool = PlaygroundTool.availableTools.firstWhere((t) => t.id == session.selectedToolId);
                            } catch (_) {}

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: InkWell(
                                onTap: () {
                                  context.read<LlmPlaygroundBloc>().add(SelectChatSessionEvent(session.id));
                                  Navigator.of(context).pop();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.indigoAccent.withValues(alpha: 0.15)
                                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.indigoAccent
                                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                      width: isSelected ? 1.5 : 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        tool?.icon ?? Icons.chat_bubble_outline_rounded,
                                        size: 16,
                                        color: isSelected ? Colors.indigoAccent : Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              session.title,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                color: isDark ? Colors.white : Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Text(
                                                  DateFormat('MMM d, hh:mm a').format(session.updatedAt),
                                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '${session.messages.length} msgs',
                                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.grey),
                                        onPressed: () {
                                          context.read<LlmPlaygroundBloc>().add(DeleteChatSessionEvent(session.id));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Clear All Button Footer
                if (state.sessions.isNotEmpty) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: () {
                          context.read<LlmPlaygroundBloc>().add(const ClearAllHistoryEvent());
                        },
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 18),
                        label: const Text(
                          'Clear All History',
                          style: TextStyle(color: Colors.redAccent, fontSize: 12),
                        ),
                      ),
                    ),
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
