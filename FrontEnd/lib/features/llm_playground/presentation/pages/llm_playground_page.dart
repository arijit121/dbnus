import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import '../../../../navigation/custom_router/custom_route.dart';
import '../../domain/entities/playground_attached_file.dart';
import '../bloc/llm_playground_bloc.dart';
import '../bloc/llm_playground_event.dart';
import '../bloc/llm_playground_state.dart';
import '../widgets/playground_chat_history_drawer.dart';
import '../widgets/playground_message_bubble.dart';

class LlmPlaygroundPage extends StatelessWidget {
  const LlmPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LlmPlaygroundBloc()..add(const InitializeModelEvent()),
      child: const _LlmPlaygroundView(),
    );
  }
}

class _LlmPlaygroundView extends StatefulWidget {
  const _LlmPlaygroundView();

  @override
  State<_LlmPlaygroundView> createState() => _LlmPlaygroundViewState();
}

class _LlmPlaygroundViewState extends State<_LlmPlaygroundView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isSpeechInitialized = false;

  @override
  void dispose() {
    _speechToText.stop();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    final bloc = context.read<LlmPlaygroundBloc>();

    if (text.isEmpty && bloc.state.attachedFile == null) return;

    if (bloc.state.isListeningToVoice) {
      _speechToText.stop();
      bloc.add(const ToggleVoiceInputEvent(isListening: false));
    }

    bloc.add(SendPlaygroundMessageEvent(text: text));
    _textController.clear();
    _scrollToBottom();
  }

  bool _checkIsImage(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    return ['png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp', 'heic', 'svg']
        .contains(ext);
  }

  Future<void> _pickAndAttachFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        final isImage = _checkIsImage(platformFile.name);
        String content = '';
        Uint8List? fileBytes = platformFile.bytes;

        if (isImage) {
          content = '[Image File: ${platformFile.name}]';
        } else {
          if (platformFile.bytes != null) {
            content = utf8.decode(platformFile.bytes!, allowMalformed: true);
          } else if (platformFile.path != null) {
            final file = File(platformFile.path!);
            content = await file.readAsString();
          }

          if (content.trim().isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Selected file is empty or unreadable.')),
              );
            }
            return;
          }
        }

        if (mounted) {
          context.read<LlmPlaygroundBloc>().add(
                AttachFileEvent(
                  PlaygroundAttachedFile(
                    name: platformFile.name,
                    path: platformFile.path,
                    content: content,
                    sizeInBytes: platformFile.size,
                    isImage: isImage,
                    bytes: fileBytes,
                  ),
                ),
              );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to read file: $e')),
        );
      }
    }
  }

  Future<void> _toggleSpeechInput() async {
    final bloc = context.read<LlmPlaygroundBloc>();
    if (bloc.state.isListeningToVoice) {
      try {
        await _speechToText.stop();
      } catch (_) {}
      bloc.add(const ToggleVoiceInputEvent(isListening: false));
      return;
    }

    // 1. Request microphone permission on mobile/desktop platforms
    if (!kIsWeb) {
      try {
        var micStatus = await Permission.microphone.status;
        if (!micStatus.isGranted) {
          micStatus = await Permission.microphone.request();
          if (!micStatus.isGranted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Microphone permission is required for speech recognition.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return;
          }
        }
      } catch (e) {
        debugPrint('Permission check error: $e');
      }
    }

    // 2. Initialize and start listening
    try {
      if (!_isSpeechInitialized) {
        _isSpeechInitialized = await _speechToText.initialize(
          onError: (err) {
            debugPrint('SpeechToText onError: ${err.errorMsg}');
            if (mounted) {
              context
                  .read<LlmPlaygroundBloc>()
                  .add(const ToggleVoiceInputEvent(isListening: false));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Speech error: ${err.errorMsg}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          onStatus: (status) {
            debugPrint('SpeechToText onStatus: $status');
            if (status == 'done' || status == 'notListening') {
              if (mounted) {
                context
                    .read<LlmPlaygroundBloc>()
                    .add(const ToggleVoiceInputEvent(isListening: false));
              }
            }
          },
          debugLogging: kDebugMode,
        );
      }

      if (_isSpeechInitialized) {
        bloc.add(const ToggleVoiceInputEvent(isListening: true));
        await _speechToText.listen(
          onResult: (result) {
            if (mounted && result.recognizedWords.isNotEmpty) {
              setState(() {
                _textController.text = result.recognizedWords;
                _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textController.text.length),
                );
              });
            }
          },
          listenOptions: stt.SpeechListenOptions(
            listenFor: const Duration(seconds: 60),
            pauseFor: const Duration(seconds: 5),
            partialResults: true,
            cancelOnError: false,
            listenMode: stt.ListenMode.dictation,
          ),
        );
      } else {
        _isSpeechInitialized = false;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Speech recognition is not available on this device/browser.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context
            .read<LlmPlaygroundBloc>()
            .add(const ToggleVoiceInputEvent(isListening: false));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition error: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ColorConst.primaryDark : ColorConst.scaffoldBg,
      drawer: const PlaygroundChatHistoryDrawer(),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => CustomRoute.back(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ColorConst.baseHexColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: ColorConst.baseHexColor, size: 20),
            ),
            10.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
                    builder: (context, state) {
                      final title =
                          state.activeSession?.title ?? 'LLM AI Assistant';
                      return CustomText(
                        title,
                        size: 15,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  BlocBuilder<LlmPlaygroundBloc, LlmPlaygroundState>(
                    builder: (context, state) {
                      Color statusColor;
                      String statusText;
                      if (state.isInitializing) {
                        statusColor = Colors.orangeAccent;
                        statusText = 'Initializing Model...';
                      } else if (state.isInitialized) {
                        statusColor = ColorConst.green;
                        statusText = 'Model Ready';
                      } else if (state.status == LlmPlaygroundStatus.error) {
                        statusColor = ColorConst.red;
                        statusText = 'Initialization Failed';
                      } else {
                        statusColor = ColorConst.grey;
                        statusText = 'Uninitialized';
                      }

                      return Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          4.pw,
                          CustomText(
                            statusText,
                            size: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: ColorConst.baseHexColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.edit_note_rounded,
                  color: ColorConst.baseHexColor, size: 20),
              tooltip: 'Start New Chat',
              onPressed: () {
                context
                    .read<LlmPlaygroundBloc>()
                    .add(const CreateNewChatEvent());
              },
            ),
          ),
          Builder(
            builder: (ctx) => Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.forum_rounded,
                    color: ColorConst.baseHexColor, size: 20),
                tooltip: 'Chat History',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<LlmPlaygroundBloc, LlmPlaygroundState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: ColorConst.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state.messages.isNotEmpty) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (state.isInitializing)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: ColorConst.lineGrey,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorConst.baseHexColor),
                  ),

                // Chat Messages or Empty Welcome State
                Expanded(
                  child: state.messages.isEmpty
                      ? _buildEmptyWelcomeState(context, state)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return PlaygroundMessageBubble(
                              message: state.messages[index],
                            );
                          },
                        ),
                ),

                // Bottom Input Area with Attachment & Speech-to-Text
                _buildBottomInputArea(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyWelcomeState(
      BuildContext context, LlmPlaygroundState state) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorConst.baseHexColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 48,
                color: ColorConst.baseHexColor,
              ),
            ),
            20.ph,
            const CustomText(
              'How can I help you today?',
              size: 22,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            8.ph,
            const CustomText(
              'Ask questions, attach images or text files, speak with voice dictation, or get code explanations.',
              size: 13,
              color: ColorConst.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInputArea(BuildContext context, LlmPlaygroundState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attached File Chip Preview
          if (state.attachedFile != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: ColorConst.baseHexColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: ColorConst.baseHexColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    state.attachedFile!.isImage
                        ? Icons.image_rounded
                        : Icons.attach_file_rounded,
                    size: 16,
                    color: ColorConst.baseHexColor,
                  ),
                  6.pw,
                  Flexible(
                    child: CustomText(
                      '${state.attachedFile!.name} (${state.attachedFile!.formattedSize})',
                      size: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorConst.baseHexColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  6.pw,
                  InkWell(
                    onTap: () {
                      context
                          .read<LlmPlaygroundBloc>()
                          .add(const RemoveAttachedFileEvent());
                    },
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: ColorConst.baseHexColor),
                  ),
                ],
              ),
            ),

          // Unified Capsule Input Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : ColorConst.lineGrey,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Attach File Compact Icon Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: state.isInitialized && !state.isGenerating
                        ? _pickAndAttachFile
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.attach_file_rounded,
                          color: ColorConst.baseHexColor, size: 20),
                    ),
                  ),
                ),

                // Speech-to-Text Microphone Compact Icon Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: state.isInitialized && !state.isGenerating
                        ? _toggleSpeechInput
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        state.isListeningToVoice
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        color: state.isListeningToVoice
                            ? ColorConst.red
                            : ColorConst.baseHexColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                4.pw,

                // Spacious Multiline Text Field
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 5,
                    enabled: state.isInitialized && !state.isGenerating,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: state.isListeningToVoice
                          ? 'Listening to voice...'
                          : (!state.isInitialized
                              ? (state.isInitializing
                                  ? 'Loading AI Model...'
                                  : 'Model Not Loaded')
                              : 'Ask anything or paste text/code...'),
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white38 : ColorConst.grey,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),

                6.pw,

                // Send or Stop Button
                if (state.isGenerating)
                  GestureDetector(
                    onTap: () {
                      context
                          .read<LlmPlaygroundBloc>()
                          .add(const StopGenerationEvent());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: ColorConst.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.stop_rounded,
                          size: 18, color: Colors.white),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: state.isInitialized ? _sendMessage : null,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: state.isInitialized
                            ? ColorConst.baseHexColor
                            : ColorConst.grey.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
