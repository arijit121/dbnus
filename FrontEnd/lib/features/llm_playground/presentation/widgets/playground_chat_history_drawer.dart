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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drawer Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.indigoAccent, Colors.purpleAccent],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.forum_rounded, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chat Sessions',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${state.sessions.length} saved conversations',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white60 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // New Chat Action Button
                      InkWell(
                        onTap: () {
                          context.read<LlmPlaygroundBloc>().add(const CreateNewChatEvent());
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.indigoAccent, Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigoAccent.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Start New Chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sessions Section Header
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        'RECENT CHATS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: isDark ? Colors.white38 : Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      if (state.sessions.isNotEmpty)
                        Text(
                          '${state.sessions.length}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent,
                          ),
                        ),
                    ],
                  ),
                ),

                // Sessions List View
                Expanded(
                  child: state.sessions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.indigoAccent.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 36,
                                    color: Colors.indigoAccent,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'No conversations yet',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap "+ Start New Chat" above to begin.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white38 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          itemCount: state.sessions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final session = state.sessions[index];
                            final isSelected = session.id == state.activeSessionId;

                            PlaygroundTool? tool;
                            try {
                              tool = PlaygroundTool.availableTools.firstWhere((t) => t.id == session.selectedToolId);
                            } catch (_) {}

                            final lastMessageText = session.messages.isNotEmpty
                                ? session.messages.last.text.trim().replaceAll('\n', ' ')
                                : 'No messages yet';

                            return InkWell(
                              onTap: () {
                                context.read<LlmPlaygroundBloc>().add(SelectChatSessionEvent(session.id));
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF))
                                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.indigoAccent
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    width: isSelected ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: Colors.indigoAccent.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    else
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Active left accent indicator
                                    if (isSelected)
                                      Container(
                                        width: 3,
                                        height: 36,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.indigoAccent,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),

                                    // Tool Icon Box
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.indigoAccent
                                            : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        tool?.icon ?? Icons.chat_bubble_rounded,
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark ? Colors.white70 : Colors.indigoAccent),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Title & Preview
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            session.title,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                              color: isSelected
                                                  ? (isDark ? Colors.white : Colors.indigo[900])
                                                  : (isDark ? Colors.white : Colors.black87),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            lastMessageText,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? Colors.white54 : Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 10,
                                                color: isDark ? Colors.white38 : Colors.grey[400],
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                DateFormat('MMM d, h:mm a').format(session.updatedAt),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: isDark ? Colors.white38 : Colors.grey[500],
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? Colors.indigoAccent.withValues(alpha: 0.2)
                                                      : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${session.messages.length} msgs',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelected ? Colors.indigoAccent : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),

                                    // Delete Session Button
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.grey),
                                      tooltip: 'Delete Chat',
                                      onPressed: () {
                                        context.read<LlmPlaygroundBloc>().add(DeleteChatSessionEvent(session.id));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Clear All Button Footer
                if (state.sessions.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<LlmPlaygroundBloc>().add(const ClearAllHistoryEvent());
                        },
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 18),
                        label: const Text(
                          'Clear All Chat History',
                          style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
