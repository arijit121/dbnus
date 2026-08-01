import 'playground_tool.dart';

class PlaygroundChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final PlaygroundToolId? toolUsed;
  final bool isStreaming;

  const PlaygroundChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.toolUsed,
    this.isStreaming = false,
  });

  PlaygroundChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    PlaygroundToolId? toolUsed,
    bool? isStreaming,
  }) {
    return PlaygroundChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      toolUsed: toolUsed ?? this.toolUsed,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}
