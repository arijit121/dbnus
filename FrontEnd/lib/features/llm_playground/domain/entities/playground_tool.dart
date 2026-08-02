import 'package:flutter/material.dart';

enum PlaygroundToolId {
  general,
  summarizer,
  codeExplainer,
  textRewriter,
  translator,
  mathLogic,
  promptStudio,
}

class PlaygroundTool {
  final PlaygroundToolId id;
  final String title;
  final String description;
  final IconData icon;
  final String promptPrefix;

  const PlaygroundTool({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.promptPrefix,
  });

  static const List<PlaygroundTool> availableTools = [
    PlaygroundTool(
      id: PlaygroundToolId.general,
      title: 'Chat Assistant',
      description: 'General conversational AI assistant for open questions and advice.',
      icon: Icons.chat_bubble_outline_rounded,
      promptPrefix: '',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.summarizer,
      title: 'Summarizer',
      description: 'Summarize articles, notes, or long text into concise bullet points.',
      icon: Icons.summarize_rounded,
      promptPrefix: 'Task: Summarize the following text in concise bullet points.\n\nText:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.codeExplainer,
      title: 'Code Explainer',
      description: 'Analyze code snippets and explain how they work step-by-step.',
      icon: Icons.code_rounded,
      promptPrefix: 'Task: Explain the following code step-by-step for a developer.\n\nCode:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.textRewriter,
      title: 'Text Rewriter',
      description: 'Rewrite, polish, or convert text to a professional tone.',
      icon: Icons.edit_note_rounded,
      promptPrefix: 'Task: Rewrite the following text to be clear, professional, and well-structured.\n\nOriginal Text:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.translator,
      title: 'Translator',
      description: 'Translate text cleanly into target languages.',
      icon: Icons.translate_rounded,
      promptPrefix: 'Task: Translate the following text into English and Spanish cleanly.\n\nText:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.mathLogic,
      title: 'Math & Logic',
      description: 'Solve mathematical problems and logical reasoning step-by-step.',
      icon: Icons.calculate_rounded,
      promptPrefix: 'Task: Solve the following math or logic question step-by-step with explanation.\n\nQuestion:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.promptStudio,
      title: 'Prompt Studio',
      description: 'Custom system instructions and prompt engineering sandbox.',
      icon: Icons.tune_rounded,
      promptPrefix: '',
    ),
  ];
}
