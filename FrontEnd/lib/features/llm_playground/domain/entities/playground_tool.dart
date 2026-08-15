import 'package:material_ui/material_ui.dart';

enum PlaygroundToolId {
  general,
  summarizer,
  codeExplainer,
  textRewriter,
  translator,
  mathLogic,
  appLauncher,
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
      description:
          'General conversational AI assistant for open questions and advice.',
      icon: Icons.chat_bubble_outline_rounded,
      promptPrefix: '',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.appLauncher,
      title: 'Device App Launcher & Installer',
      description:
          'Launch installed device apps, search contacts directory, open store installation pages, trigger calls, maps, WhatsApp, and device utilities.',
      icon: Icons.apps_rounded,
      promptPrefix:
          'Task: You are an intelligent device app launcher, contact directory & store assistant. Assist the user with searching device contacts, calling phone numbers, launching installed device apps, or downloading apps from the store.\n'
          'Rules for Contact & Call Requests (e.g. "call mother", "call mom", "call john"):\n'
          '1. Search the contact directory for matching contacts.\n'
          '2. If multiple numbers or entries exist (e.g. Mobile, Home, Work), list all found options clearly with actionable call links (e.g., tel:number, https://wa.me/number) and ask the user to select which number to call.\n'
          '3. Output actionable links for all actions (e.g. Call: tel:number, WhatsApp: https://wa.me/number, Email: mailto:address, Store: https://play.google.com/store/search?q=appname).\n\nRequest:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.summarizer,
      title: 'Summarizer',
      description:
          'Summarize articles, notes, or long text into concise bullet points.',
      icon: Icons.summarize_rounded,
      promptPrefix:
          'Task: Summarize the following text in concise bullet points.\n\nText:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.codeExplainer,
      title: 'Code Explainer',
      description:
          'Analyze code snippets and explain how they work step-by-step.',
      icon: Icons.code_rounded,
      promptPrefix:
          'Task: Explain the following code step-by-step for a developer.\n\nCode:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.textRewriter,
      title: 'Text Rewriter',
      description: 'Rewrite, polish, or convert text to a professional tone.',
      icon: Icons.edit_note_rounded,
      promptPrefix:
          'Task: Rewrite the following text to be clear, professional, and well-structured.\n\nOriginal Text:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.translator,
      title: 'Translator',
      description: 'Translate text cleanly into target languages.',
      icon: Icons.translate_rounded,
      promptPrefix:
          'Task: Translate the following text into English cleanly.\n\nText:\n',
    ),
    PlaygroundTool(
      id: PlaygroundToolId.mathLogic,
      title: 'Math & Logic',
      description:
          'Solve mathematical problems and logical reasoning step-by-step.',
      icon: Icons.calculate_rounded,
      promptPrefix:
          'Task: Solve the following math or logic question step-by-step with explanation.\n\nQuestion:\n',
    ),
  ];

  static PlaygroundTool detectTool(String query) {
    final lower = query.toLowerCase().trim();

    // App & Device launcher keywords
    final appKeywords = [
      'open app',
      'launch app',
      'install app',
      'install ',
      'download app',
      'get app',
      'play store',
      'app store',
      'store app',
      'open whatsapp',
      'open youtube',
      'open camera',
      'open maps',
      'open settings',
      'open chrome',
      'open browser',
      'open gmail',
      'call ',
      'dial ',
      'send email',
      'send mail',
      'open website',
      'open link',
      'device app',
      'installed app'
    ];
    if (appKeywords.any((k) => lower.contains(k))) {
      return availableTools
          .firstWhere((t) => t.id == PlaygroundToolId.appLauncher);
    }

    // Code detection
    final codeKeywords = [
      'class ',
      'function ',
      'def ',
      'const ',
      'var ',
      'let ',
      'void ',
      'import ',
      'return ',
      'if (',
      'for (',
      'while (',
      'select ',
      'from ',
      'where ',
      '```',
      'syntax error',
      'bug in',
      'explain this code'
    ];
    final hasCodeSyntax = lower.contains('```') ||
        (lower.contains('{') && lower.contains('}')) ||
        (lower.contains(';') &&
            (lower.contains('var') ||
                lower.contains('const') ||
                lower.contains('let') ||
                lower.contains('int') ||
                lower.contains('string')));
    if (codeKeywords.any((k) => lower.contains(k)) || hasCodeSyntax) {
      return availableTools
          .firstWhere((t) => t.id == PlaygroundToolId.codeExplainer);
    }

    // Summarizer detection
    final summaryKeywords = [
      'summarize',
      'summary',
      'bullet points',
      'tl;dr',
      'tldr',
      'key takeaways',
      'brief overview',
      'shorten this'
    ];
    if (summaryKeywords.any((k) => lower.contains(k))) {
      return availableTools
          .firstWhere((t) => t.id == PlaygroundToolId.summarizer);
    }

    // Translator detection
    final translateKeywords = [
      'translate',
      'translation',
      'in spanish',
      'in french',
      'in german',
      'in hindi',
      'in japanese',
      'in chinese',
      'in english',
      'to spanish',
      'to french',
      'to german',
      'to hindi',
      'to japanese'
    ];
    if (translateKeywords.any((k) => lower.contains(k))) {
      return availableTools
          .firstWhere((t) => t.id == PlaygroundToolId.translator);
    }

    // Math & Logic detection
    final mathKeywords = [
      'solve for',
      'calculate',
      'integrate',
      'derivative',
      'equation',
      'math problem',
      'logic puzzle',
      'sqrt('
    ];
    final hasMathOperators =
        RegExp(r'\d+\s*[\+\-\*/\^=]\s*\d+').hasMatch(lower);
    if (mathKeywords.any((k) => lower.contains(k)) || hasMathOperators) {
      return availableTools
          .firstWhere((t) => t.id == PlaygroundToolId.mathLogic);
    }

    // Text Rewriter detection
    final rewriteKeywords = [
      'rewrite',
      'rephrase',
      'polish',
      'improve this',
      'proofread',
      'make it professional',
      'fix grammar'
    ];
    if (rewriteKeywords.any((k) => lower.contains(k))) {
      return availableTools
          .firstWhere((t) => t.id == PlaygroundToolId.textRewriter);
    }

    // General default
    return availableTools.firstWhere((t) => t.id == PlaygroundToolId.general);
  }
}
