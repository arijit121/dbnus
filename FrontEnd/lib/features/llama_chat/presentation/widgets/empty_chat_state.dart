import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

class EmptyChatState extends StatelessWidget {
  const EmptyChatState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smart_toy_outlined,
            size: 64,
            color: isDark ? Colors.indigoAccent.shade100 : Colors.indigoAccent,
          ),
          const SizedBox(height: 16),
          CustomText(
            'LlamaDart Local AI',
            size: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: CustomText(
              'Load a GGUF model path or URL above to start private, local LLM chat inference.',
              textAlign: TextAlign.center,
              size: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
