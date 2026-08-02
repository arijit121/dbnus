import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import '../../domain/entities/playground_chat_message.dart';

class PlaygroundMessageBubble extends StatelessWidget {
  final PlaygroundChatMessage message;

  const PlaygroundMessageBubble({
    super.key,
    required this.message,
  });

  List<_MessageSegment> _parseSegments(String rawText) {
    final segments = <_MessageSegment>[];
    final regExp =
        RegExp(r'```([a-zA-Z0-9_\-\+]*)\n?([\s\S]*?)```', multiLine: true);
    int lastEnd = 0;

    for (final match in regExp.allMatches(rawText)) {
      if (match.start > lastEnd) {
        final textBefore = rawText.substring(lastEnd, match.start);
        if (textBefore.isNotEmpty) {
          segments.add(_MessageSegment(text: textBefore, isCode: false));
        }
      }

      final lang = match.group(1)?.trim() ?? '';
      final code = match.group(2) ?? '';
      segments.add(_MessageSegment(
        text: code.trimRight(),
        isCode: true,
        language: lang.isEmpty ? 'code' : lang,
      ));
      lastEnd = match.end;
    }

    if (lastEnd < rawText.length) {
      final textAfter = rawText.substring(lastEnd);
      if (textAfter.isNotEmpty) {
        segments.add(_MessageSegment(text: textAfter, isCode: false));
      }
    }

    if (segments.isEmpty) {
      segments.add(_MessageSegment(text: rawText, isCode: false));
    }

    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUser = message.isUser;
    final textContent = message.text.isEmpty && message.isStreaming
        ? 'Thinking...'
        : message.text;
    final segments = _parseSegments(textContent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: ColorConst.baseHexColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 16),
            ),
            8.pw,
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? ColorConst.baseHexColor
                    : (isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: !isUser
                    ? Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : ColorConst.lineGrey)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...segments.map((seg) {
                    if (seg.isCode) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _PlaygroundCodeViewer(
                          code: seg.text,
                          language: seg.language,
                        ),
                      );
                    }
                    final textHasUrl = seg.text.contains('http://') ||
                        seg.text.contains('https://') ||
                        seg.text.contains('tel:') ||
                        seg.text.contains('mailto:') ||
                        seg.text.contains('wa.me') ||
                        seg.text.contains('href=');

                    if (textHasUrl) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: CustomHtmlText(
                          seg.text.replaceAll('\n', '<br/>'),
                          size: 13,
                          height: 1.4,
                          color: isUser
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      );
                    }

                    return SelectableText(
                      seg.text,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isUser
                            ? Colors.white
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    );
                  }),
                  4.ph,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        DateFormat('hh:mm a').format(message.timestamp),
                        size: 10,
                        color: isUser ? Colors.white70 : ColorConst.grey,
                      ),
                      if (!isUser && message.text.isNotEmpty) ...[
                        8.pw,
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: message.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied response to clipboard'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Icon(Icons.copy_rounded,
                              size: 12, color: ColorConst.grey),
                        ),
                      ],
                      if (message.isStreaming) ...[
                        6.pw,
                        const SizedBox(
                          width: 8,
                          height: 8,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: ColorConst.baseHexColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            8.pw,
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : ColorConst.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                color: isDark ? Colors.white70 : Colors.black87,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageSegment {
  final String text;
  final bool isCode;
  final String language;

  _MessageSegment({
    required this.text,
    required this.isCode,
    this.language = 'code',
  });
}

class _PlaygroundCodeViewer extends StatefulWidget {
  final String code;
  final String language;

  const _PlaygroundCodeViewer({
    required this.code,
    required this.language,
  });

  @override
  State<_PlaygroundCodeViewer> createState() => _PlaygroundCodeViewerState();
}

class _PlaygroundCodeViewerState extends State<_PlaygroundCodeViewer> {
  bool _copied = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.code.split('\n');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: const Color(0xFF1E293B),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code_rounded,
                        size: 14, color: Colors.indigoAccent),
                    const SizedBox(width: 6),
                    Text(
                      widget.language.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.indigoAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _copyCode,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          _copied ? Icons.check_rounded : Icons.copy_rounded,
                          size: 12,
                          color: _copied ? Colors.greenAccent : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _copied ? 'Copied!' : 'Copy Code',
                          style: TextStyle(
                            color:
                                _copied ? Colors.greenAccent : Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Code Content Box with Line Numbers
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Line numbers
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      lines.length,
                      (idx) => Text(
                        '${idx + 1}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          height: 1.4,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 1,
                    height: lines.length * 15.4,
                    color: const Color(0xFF334155),
                  ),
                  const SizedBox(width: 12),
                  // Code Text
                  SelectableText(
                    widget.code,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      height: 1.4,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
