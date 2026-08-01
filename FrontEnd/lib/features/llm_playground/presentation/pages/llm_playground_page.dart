import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:llamadart/llamadart.dart';

import '../../../../navigation/custom_router/custom_route.dart';
import '../../services/playground_llama_service.dart';
import '../widgets/playground_model_config_card.dart';

enum PlaygroundMode {
  summarizer('Summarizer', Icons.summarize_rounded, 'Summarize long articles or notes into key bullet points.'),
  codeExplainer('Code Explainer', Icons.code_rounded, 'Analyze code snippets and explain how they work step-by-step.'),
  textRewriter('Text Rewriter', Icons.edit_note_rounded, 'Rewrite text in a professional, clear, or concise tone.'),
  promptStudio('Prompt Studio', Icons.tune_rounded, 'Experiment with custom system prompts and user inputs.');

  final String title;
  final IconData icon;
  final String description;

  const PlaygroundMode(this.title, this.icon, this.description);
}

class LlmPlaygroundPage extends StatefulWidget {
  const LlmPlaygroundPage({super.key});

  @override
  State<LlmPlaygroundPage> createState() => _LlmPlaygroundPageState();
}

class _LlmPlaygroundPageState extends State<LlmPlaygroundPage> {
  final PlaygroundLlamaService _llamaService = PlaygroundLlamaService();
  final TextEditingController _modelPathController = TextEditingController(
    text: kIsWeb
        ? 'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf'
        : 'assets/models/ai/model.gguf',
  );
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _systemPromptController = TextEditingController(
    text: 'You are an intelligent, helpful AI assistant running locally via LlamaDart.',
  );
  final ScrollController _scrollController = ScrollController();

  PlaygroundMode _selectedMode = PlaygroundMode.summarizer;
  bool _isInitializing = false;
  String? _statusMessage;
  String _outputText = '';
  bool _isGenerating = false;
  StreamSubscription<LlamaCompletionChunk>? _streamSub;

  final Map<PlaygroundMode, List<Map<String, String>>> _presets = {
    PlaygroundMode.summarizer: [
      {
        'title': 'AI Overview',
        'text':
            'Artificial Intelligence (AI) refers to the simulation of human intelligence in machines that are programmed to think and learn like humans. Recent advancements in On-Device Machine Learning allow Large Language Models to run directly on smartphones and personal computers without sending data to external servers.',
      },
      {
        'title': 'Flutter & Dart',
        'text':
            'Flutter is Google’s open-source UI software development kit used to craft natively compiled applications for mobile, web, and desktop from a single codebase. It uses Dart, a client-optimized language for fast apps on any platform.',
      },
    ],
    PlaygroundMode.codeExplainer: [
      {
        'title': 'Dart Stream',
        'text':
            'Stream<int> countStream(int to) async* {\n  for (int i = 1; i <= to; i++) {\n    yield i;\n  }\n}',
      },
      {
        'title': 'Flutter BLoC',
        'text':
            'class CounterBloc extends Bloc<CounterEvent, int> {\n  CounterBloc() : super(0) {\n    on<Increment>((event, emit) => emit(state + 1));\n  }\n}',
      },
    ],
    PlaygroundMode.textRewriter: [
      {
        'title': 'Casual to Professional',
        'text': 'Hey team, just wanted to check if the new build is ready or if there are any blocking bugs left.',
      },
      {
        'title': 'Simplify Concept',
        'text':
            'Quantization is a technique that reduces the memory footprint of neural network weights by converting 32-bit floating-point numbers into 4-bit integers.',
      },
    ],
    PlaygroundMode.promptStudio: [
      {
        'title': 'Recipe Ideas',
        'text': 'I have eggs, spinach, tomatoes, and cheese. What quick meal can I make in 10 minutes?',
      },
      {
        'title': 'Creative Story',
        'text': 'Write a 3-sentence sci-fi opening line about a lighthouse on Mars.',
      },
    ],
  };

  @override
  void dispose() {
    _streamSub?.cancel();
    _llamaService.dispose();
    _modelPathController.dispose();
    _inputController.dispose();
    _systemPromptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeModel() async {
    final path = _modelPathController.text.trim();
    if (path.isEmpty) return;

    setState(() {
      _isInitializing = true;
      _statusMessage = 'Loading model weights...';
    });

    try {
      await _llamaService.initialize(modelPath: path);
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _statusMessage = 'Model Initialized';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _statusMessage = 'Failed to load model';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing model: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _runPlayground() {
    final rawInput = _inputController.text.trim();
    if (rawInput.isEmpty || !_llamaService.isInitialized || _isGenerating) return;

    String fullPrompt = '';
    switch (_selectedMode) {
      case PlaygroundMode.summarizer:
        fullPrompt = 'Task: Summarize the following text in concise bullet points.\n\nText:\n$rawInput';
        break;
      case PlaygroundMode.codeExplainer:
        fullPrompt = 'Task: Explain the following code step-by-step for a developer.\n\nCode:\n$rawInput';
        break;
      case PlaygroundMode.textRewriter:
        fullPrompt = 'Task: Rewrite the following text to be professional, clear, and engaging.\n\nOriginal Text:\n$rawInput';
        break;
      case PlaygroundMode.promptStudio:
        final sys = _systemPromptController.text.trim();
        fullPrompt = sys.isNotEmpty ? 'System: $sys\n\nUser: $rawInput' : rawInput;
        break;
    }

    setState(() {
      _outputText = '';
      _isGenerating = true;
    });

    _streamSub?.cancel();
    final stream = _llamaService.createChatStream(fullPrompt);
    if (stream == null) {
      setState(() {
        _isGenerating = false;
        _outputText = '[Error creating generation stream]';
      });
      return;
    }

    _streamSub = stream.listen(
      (chunk) {
        if (chunk.choices.isNotEmpty) {
          final content = chunk.choices.first.delta.content;
          if (content != null && content.isNotEmpty && mounted) {
            setState(() {
              _outputText += content;
            });
          }
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            _isGenerating = false;
            _outputText += '\n[Error: $err]';
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isGenerating = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => CustomRoute.back(),
        ),
        title: const Row(
          children: [
            Icon(Icons.science_rounded, color: Colors.indigoAccent, size: 24),
            SizedBox(width: 10),
            Text(
              'LLM Prompt Studio & Tools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Model Config Card
              PlaygroundModelConfigCard(
                controller: _modelPathController,
                isInitializing: _isInitializing,
                isInitialized: _llamaService.isInitialized,
                statusMessage: _statusMessage,
                onInitialize: _initializeModel,
              ),

              const SizedBox(height: 12),

              // Mode Switcher Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: PlaygroundMode.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final mode = PlaygroundMode.values[index];
                      final isSelected = mode == _selectedMode;
                      return ChoiceChip(
                        avatar: Icon(
                          mode.icon,
                          size: 16,
                          color: isSelected ? Colors.white : Colors.indigoAccent,
                        ),
                        label: Text(mode.title),
                        selected: isSelected,
                        selectedColor: Colors.indigoAccent,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedMode = mode;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Mode Description Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(_selectedMode.icon, color: Colors.indigoAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedMode.description,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Sample Presets
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text('Presets: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      ...(_presets[_selectedMode] ?? []).map(
                        (preset) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ActionChip(
                            label: Text(preset['title']!, style: const TextStyle(fontSize: 11)),
                            onPressed: () {
                              setState(() {
                                _inputController.text = preset['text']!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // System Prompt Input for Studio mode
              if (_selectedMode == PlaygroundMode.promptStudio) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _systemPromptController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'System Instruction',
                      isDense: true,
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Input Text Area Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Input Text',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Spacer(),
                        if (_inputController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: Colors.grey),
                            tooltip: 'Clear input',
                            onPressed: () => setState(() => _inputController.clear()),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _inputController,
                      maxLines: 5,
                      minLines: 3,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter text, prompt, or code snippet here...',
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: (_isGenerating || !_llamaService.isInitialized || _inputController.text.trim().isEmpty)
                            ? null
                            : _runPlayground,
                        icon: _isGenerating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.auto_awesome_rounded),
                        label: Text(
                          _isGenerating
                              ? 'Generating...'
                              : (!_llamaService.isInitialized ? 'Initialize Model First' : 'Run ${_selectedMode.title}'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Output Response Display Card
              if (_outputText.isNotEmpty || _isGenerating) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF1E1B4B), const Color(0xFF0F172A)]
                          : [const Color(0xFFEEF2FF), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_rounded, color: Colors.indigoAccent, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'AI Output',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const Spacer(),
                          if (_outputText.isNotEmpty) ...[
                            Text(
                              '${_outputText.length} chars',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.indigoAccent),
                              tooltip: 'Copy Output',
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _outputText));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied output to clipboard!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                      const Divider(height: 16),
                      SelectableText(
                        _outputText.isEmpty && _isGenerating ? 'Generating response...' : _outputText,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
