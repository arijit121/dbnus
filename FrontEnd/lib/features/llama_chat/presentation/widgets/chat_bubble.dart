import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import '../../domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.indigoAccent
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.text.isEmpty && !isUser)
              const SizedBox(
                height: 20,
                width: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: Colors.indigoAccent),
                    CircleAvatar(radius: 3, backgroundColor: Colors.indigoAccent),
                    CircleAvatar(radius: 3, backgroundColor: Colors.indigoAccent),
                  ],
                ),
              )
            else
              SelectableText(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: isUser
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            const SizedBox(height: 4),
            CustomText(
              '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              size: 10,
              color: isUser
                  ? Colors.white70
                  : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
