import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

import 'card_shell.dart';
import 'section_title.dart';

class SkillsCard extends StatelessWidget {
  const SkillsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: FeatherIcons.cpu,
          title: "Skills",
          color: const Color(0xFFE67E22),
        ),
        CardShell(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _skillChip('Flutter', 'Expert', ColorConst.lightBlue),
              _skillChip('Node.js', 'Expert', ColorConst.deepGreen),
              _skillChip('Git', 'Expert', ColorConst.red),
              _skillChip('MS Office', 'Expert', const Color(0xFFE67E22)),
              _skillChip('MVVM', 'Expert', const Color(0xFF2980B9)),
              _skillChip('Agile', 'Expert', const Color(0xFF27AE60)),
              _skillChip('Socket.IO', 'Skillful', const Color(0xFF010101)),
              _skillChip(
                  'CI/CD (Codemagic)', 'Skillful', const Color(0xFFFC6D26)),
              _skillChip(
                  'Push Notification', 'Skillful', const Color(0xFFE74C3C)),
              _skillChip('Localization', 'Skillful', const Color(0xFF1ABC9C)),
              _skillChip('Deep Link', 'Skillful', const Color(0xFF3498DB)),
              _skillChip('JavaScript', 'Skillful', ColorConst.violate),
              _skillChip('Java', 'Skillful', ColorConst.primaryDark),
              _skillChip('MySQL', 'Skillful', const Color(0xFF16A085)),
              _skillChip('SQL', 'Skillful', const Color(0xFF8E44AD)),
              _skillChip('Python', 'Experienced', ColorConst.deepBlue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _skillChip(String name, String level, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          6.pw,
          CustomText(name, size: 12, fontWeight: FontWeight.w600, color: color),
          4.pw,
          CustomText(
            '• $level',
            size: 10,
            color: color.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
