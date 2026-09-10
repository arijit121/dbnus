import 'package:material_ui/material_ui.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:dbnus/shared/ui/atoms/decorations/glass_container.dart';
import 'package:dbnus/features/gods_eye_view/domain/entities/sensor_mode.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_bloc.dart';
import 'package:dbnus/features/gods_eye_view/presentation/bloc/gods_eye_view_event.dart';

class VoiceAnalystDialog extends StatefulWidget {
  final GodsEyeViewBloc bloc;
  final SensorMode sensorMode;

  const VoiceAnalystDialog({
    super.key,
    required this.bloc,
    required this.sensorMode,
  });

  @override
  State<VoiceAnalystDialog> createState() => _VoiceAnalystDialogState();
}

class _VoiceAnalystDialogState extends State<VoiceAnalystDialog> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  final List<String> _quickCommands = [
    'Switch to NVG',
    'Switch to FLIR',
    'Switch to CRT',
    'Track military flight',
    'Enter cockpit',
    'Fly to Tokyo',
    'Fly to London',
    'Show earthquakes',
    'Track ISS satellite',
    'Reset globe',
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onError: (_) {
          if (mounted) setState(() => _isListening = false);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
      );
      if (mounted) {
        setState(() {
          _speechAvailable = available;
        });
      }
    } catch (_) {
      // Speech unavailable on some desktop/web configurations; fallback to text
    }
  }

  void _toggleListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Microphone speech-to-text not supported in this runtime. Use text prompt below.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
          if (result.finalResult) {
            _submitCommand(result.recognizedWords);
          }
        },
      );
    }
  }

  void _submitCommand(String command) {
    final text = command.trim();
    if (text.isEmpty) return;
    widget.bloc.add(ExecuteVoiceOrTextCommand(text));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hudColor = widget.sensorMode.hudColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: GlassContainer(
          blur: 16,
          borderRadius: 12,
          color: const Color(0xFF0C0C14).withValues(alpha: 0.94),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Title
            Row(
              children: [
                Icon(Icons.mic, color: hudColor, size: 22),
                const SizedBox(width: 8),
                Text(
                  'AI TACTICAL ANALYST // VOICE CONSOLE',
                  style: TextStyle(
                    color: hudColor,
                    fontSize: 13,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white60),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mic Pulse Button
            Center(
              child: GestureDetector(
                onTap: _toggleListening,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening
                        ? const Color(0xFFFF5252).withValues(alpha: 0.25)
                        : hudColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: _isListening
                          ? const Color(0xFFFF5252)
                          : hudColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening
                                ? const Color(0xFFFF5252)
                                : hudColor)
                            .withValues(alpha: 0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? const Color(0xFFFF5252) : hudColor,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _isListening
                    ? 'LISTENING... SPEAK NOW'
                    : 'TAP TO SPEAK OR ENTER PROMPT',
                style: TextStyle(
                  color: _isListening ? const Color(0xFFFF5252) : hudColor,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Text Input
            TextField(
              controller: _textController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. "Switch to NVG", "Fly to Tokyo", "Enter cockpit"',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color: hudColor.withValues(alpha: 0.4), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                      color: hudColor.withValues(alpha: 0.4), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: hudColor, width: 1.5),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: hudColor),
                  onPressed: () => _submitCommand(_textController.text),
                ),
              ),
              onSubmitted: _submitCommand,
            ),
            const SizedBox(height: 16),

            // Quick Operator Verbs
            Text(
              '// TACTICAL QUICK COMMANDS',
              style: TextStyle(
                color: hudColor.withValues(alpha: 0.7),
                fontSize: 10,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _quickCommands.map((cmd) {
                return InkWell(
                  onTap: () => _submitCommand(cmd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: hudColor.withValues(alpha: 0.1),
                      border: Border.all(
                          color: hudColor.withValues(alpha: 0.3), width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      cmd,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ),
  );
}
}
