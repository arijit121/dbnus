import 'playground_chat_message.dart';
import 'playground_tool.dart';

class PlaygroundChatSession {
  final String id;
  final String title;
  final List<PlaygroundChatMessage> messages;
  final PlaygroundToolId selectedToolId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlaygroundChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.selectedToolId,
    required this.createdAt,
    required this.updatedAt,
  });

  PlaygroundChatSession copyWith({
    String? id,
    String? title,
    List<PlaygroundChatMessage>? messages,
    PlaygroundToolId? selectedToolId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlaygroundChatSession(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      selectedToolId: selectedToolId ?? this.selectedToolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
