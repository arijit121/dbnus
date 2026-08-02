import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class PlaygroundModelConfigCard extends StatefulWidget {
  final TextEditingController controller;
  final bool isInitializing;
  final bool isInitialized;
  final String? statusMessage;
  final VoidCallback onInitialize;

  const PlaygroundModelConfigCard({
    super.key,
    required this.controller,
    required this.isInitializing,
    required this.isInitialized,
    required this.statusMessage,
    required this.onInitialize,
  });

  @override
  State<PlaygroundModelConfigCard> createState() => _PlaygroundModelConfigCardState();
}

class _PlaygroundModelConfigCardState extends State<PlaygroundModelConfigCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = !widget.isInitialized;
  }

  @override
  void didUpdateWidget(covariant PlaygroundModelConfigCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isInitialized && widget.isInitialized) {
      setState(() {
        _isExpanded = false;
      });
    }
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
          widget.controller.text = path;
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

  bool get _isLocalFile {
    final text = widget.controller.text.trim();
    return text.isNotEmpty && !text.startsWith('http://') && !text.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isInitializing)
            const LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: ColorConst.lineGrey,
              valueColor: AlwaysStoppedAnimation<Color>(ColorConst.baseHexColor),
            ),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.storage_rounded, size: 18, color: ColorConst.baseHexColor),
                  8.pw,
                  const CustomText(
                    'Model Configuration',
                    fontWeight: FontWeight.w600,
                    size: 13,
                  ),
                  const Spacer(),
                  if (widget.isInitializing) ...[
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorConst.baseHexColor,
                      ),
                    ),
                    6.pw,
                  ] else if (widget.statusMessage != null) ...[
                    Flexible(
                      child: CustomText(
                        widget.statusMessage!,
                        overflow: TextOverflow.ellipsis,
                        size: 11,
                        fontWeight: FontWeight.w500,
                        color: widget.isInitialized ? ColorConst.green : Colors.orangeAccent,
                      ),
                    ),
                  ],
                  6.pw,
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, size: 20, color: ColorConst.grey),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  10.ph,
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          enabled: !widget.isInitializing,
                          style: const TextStyle(fontSize: 13),
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Enter local .gguf path, URL, or asset:',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.folder_open_rounded, size: 20, color: ColorConst.baseHexColor),
                              tooltip: 'Pick local .gguf file',
                              onPressed: widget.isInitializing ? null : _pickLocalModelFile,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      8.pw,
                      ElevatedButton(
                        onPressed: widget.isInitializing ? null : widget.onInitialize,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConst.baseHexColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        child: Text(
                          widget.isInitializing
                              ? 'Loading...'
                              : (widget.isInitialized ? 'Reload' : 'Init'),
                        ),
                      ),
                    ],
                  ),
                  8.ph,
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _isLocalFile
                              ? ColorConst.green.withValues(alpha: 0.15)
                              : ColorConst.lightBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _isLocalFile
                                ? ColorConst.green.withValues(alpha: 0.4)
                                : ColorConst.lightBlue.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isLocalFile ? Icons.folder_rounded : Icons.cloud_download_rounded,
                              size: 12,
                              color: _isLocalFile ? ColorConst.green : ColorConst.lightBlue,
                            ),
                            4.pw,
                            CustomText(
                              _isLocalFile ? 'Local Target' : 'Remote URL Target',
                              size: 11,
                              fontWeight: FontWeight.bold,
                              color: _isLocalFile ? ColorConst.green : ColorConst.lightBlue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  8.ph,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.inventory_2_rounded, size: 14, color: ColorConst.violate),
                          label: Text(
                            kIsWeb ? 'Bundled Asset (Native App Only)' : 'Bundled Asset (.gguf)',
                            style: const TextStyle(fontSize: 11),
                          ),
                          onPressed: widget.isInitializing
                              ? null
                              : () {
                                  if (kIsWeb) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Bundled GGUF asset models (assets/models/ai/...) are reserved for native app execution (Android, iOS, Windows, macOS, Linux). For Web, please select a remote model URL.',
                                        ),
                                        backgroundColor: Colors.orangeAccent,
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    widget.controller.text = 'assets/models/ai/model.gguf';
                                  });
                                },
                        ),
                        6.pw,
                        ActionChip(
                          avatar: const Icon(Icons.folder_open, size: 14, color: ColorConst.green),
                          label: const Text('Browse Device .gguf', style: TextStyle(fontSize: 11)),
                          onPressed: widget.isInitializing ? null : _pickLocalModelFile,
                        ),
                        6.pw,
                        ActionChip(
                          avatar: const Icon(Icons.flash_on, size: 14, color: Colors.amber),
                          label: const Text('SmolLM2 (135M ~100MB)', style: TextStyle(fontSize: 11)),
                          onPressed: widget.isInitializing
                              ? null
                              : () {
                                  setState(() {
                                    widget.controller.text =
                                        'https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf';
                                  });
                                },
                        ),
                        6.pw,
                        ActionChip(
                          avatar: const Icon(Icons.psychology, size: 14, color: ColorConst.lightBlue),
                          label: const Text('Qwen2.5 (0.5B ~398MB)', style: TextStyle(fontSize: 11)),
                          onPressed: widget.isInitializing
                              ? null
                              : () {
                                  setState(() {
                                    widget.controller.text =
                                        'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf';
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                  if (kIsWeb) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Colors.amber),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Web Notice: WebGPU WASM bridge is required for Web browser execution.',
                              style: TextStyle(fontSize: 11, color: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
