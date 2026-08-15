import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import '../../../../shared/constants/assects_const.dart';
import '../bloc/llm_playground_bloc.dart';
import '../bloc/llm_playground_event.dart';
import '../bloc/llm_playground_state.dart';

class PlaygroundModelConfigSheet extends StatefulWidget {
  const PlaygroundModelConfigSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: BlocProvider.of<LlmPlaygroundBloc>(context),
        child: const PlaygroundModelConfigSheet(),
      ),
    );
  }

  @override
  State<PlaygroundModelConfigSheet> createState() =>
      _PlaygroundModelConfigSheetState();
}

class _PlaygroundModelConfigSheetState
    extends State<PlaygroundModelConfigSheet> {
  late TextEditingController _modelPathController;
  late TextEditingController _systemPromptController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<LlmPlaygroundBloc>();
    _modelPathController = TextEditingController(text: bloc.state.modelPath);
    _systemPromptController =
        TextEditingController(text: bloc.state.systemPrompt);
  }

  @override
  void dispose() {
    _modelPathController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  Future<void> _pickLocalModelFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        dialogTitle: 'Select Local GGUF Model File',
      );
      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        setState(() {
          _modelPathController.text = path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting local model file: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : ColorConst.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              16.ph,

              Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      color: ColorConst.baseHexColor, size: 22),
                  8.pw,
                  const CustomText(
                    'AI Settings & Models',
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              16.ph,

              // Model Path Input Label
              const CustomText(
                'Model Weight Path / Remote URL',
                size: 12,
                fontWeight: FontWeight.bold,
                color: ColorConst.grey,
              ),
              6.ph,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _modelPathController,
                      enabled: !state.isInitializing,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter local .gguf path or URL',
                        isDense: true,
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.folder_open_rounded,
                              size: 20, color: ColorConst.baseHexColor),
                          tooltip: 'Pick local .gguf file',
                          onPressed:
                              state.isInitializing ? null : _pickLocalModelFile,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  8.pw,
                  ElevatedButton(
                    onPressed: state.isInitializing
                        ? null
                        : () {
                            final path = _modelPathController.text.trim();
                            if (path.isNotEmpty) {
                              context
                                  .read<LlmPlaygroundBloc>()
                                  .add(InitializeModelEvent(modelPath: path));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.baseHexColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(state.isInitializing ? 'Loading...' : 'Apply'),
                  ),
                ],
              ),

              10.ph,

              // Preset Model Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.flash_on,
                          size: 14, color: Colors.amber),
                      label: const Text('SmolLM2 (135M ~100MB)',
                          style: TextStyle(fontSize: 11)),
                      onPressed: state.isInitializing
                          ? null
                          : () {
                              setState(() {
                                _modelPathController.text =
                                    'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf';
                              });
                            },
                    ),
                    6.pw,
                    ActionChip(
                      avatar: const Icon(Icons.psychology,
                          size: 14, color: ColorConst.lightBlue),
                      label: const Text('Qwen2.5 (0.5B ~398MB)',
                          style: TextStyle(fontSize: 11)),
                      onPressed: state.isInitializing
                          ? null
                          : () {
                              setState(() {
                                _modelPathController.text =
                                    'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf';
                              });
                            },
                    ),
                    if (!kIsWeb) ...[
                      6.pw,
                      ActionChip(
                        avatar: const Icon(Icons.inventory_2_rounded,
                            size: 14, color: ColorConst.violate),
                        label: const Text('Bundled Asset (.gguf)',
                            style: TextStyle(fontSize: 11)),
                        onPressed: state.isInitializing
                            ? null
                            : () {
                                setState(() {
                                  _modelPathController.text =
                                      AssetsConst.smolLmAiModelGguf;
                                });
                              },
                      ),
                    ],
                  ],
                ),
              ),

              16.ph,

              // System Prompt Input
              const CustomText(
                'System Instruction Prompt',
                size: 12,
                fontWeight: FontWeight.bold,
                color: ColorConst.grey,
              ),
              6.ph,
              TextField(
                controller: _systemPromptController,
                maxLines: 3,
                minLines: 2,
                style: const TextStyle(fontSize: 13),
                onChanged: (text) {
                  context
                      .read<LlmPlaygroundBloc>()
                      .add(UpdateSystemPromptEvent(text));
                },
                decoration: InputDecoration(
                  hintText: 'Enter AI system instruction context...',
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              16.ph,

              // Clear Chat Action
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context
                        .read<LlmPlaygroundBloc>()
                        .add(const ClearChatEvent());
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: ColorConst.red, size: 18),
                  label: const CustomText('Clear Chat Conversation',
                      color: ColorConst.red),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: ColorConst.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
