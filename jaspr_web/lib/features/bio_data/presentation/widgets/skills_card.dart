import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class SkillsCard extends StatelessComponent {
  const SkillsCard({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          icon: AssetsConst.featherCpu,
          title: "Skills",
          color: Color('#E67E22'),
        ),
        CardShell(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _skillChip('Flutter', 'Expert', ColorConst.lightBlue),
              _skillChip('Node.js', 'Expert', ColorConst.deepGreen),
              _skillChip('Git', 'Expert', ColorConst.red),
              _skillChip('MS Office', 'Expert', const Color('#E67E22')),
              _skillChip('MVVM', 'Expert', const Color('#2980B9')),
              _skillChip('Agile', 'Expert', const Color('#27AE60')),
              _skillChip('Socket.IO', 'Skillful', const Color('#010101')),
              _skillChip('CI/CD (Codemagic)', 'Skillful', const Color('#FC6D26')),
              _skillChip('Push Notification', 'Skillful', const Color('#E74C3C')),
              _skillChip('Localization', 'Skillful', const Color('#1ABC9C')),
              _skillChip('Deep Link', 'Skillful', const Color('#3498DB')),
              _skillChip('JavaScript', 'Skillful', ColorConst.violate),
              _skillChip('Java', 'Skillful', ColorConst.primaryDark),
              _skillChip('MySQL', 'Skillful', const Color('#16A085')),
              _skillChip('SQL', 'Skillful', const Color('#8E44AD')),
              _skillChip('Python', 'Experienced', ColorConst.deepBlue),
            ],
          ),
        ),
      ],
    );
  }

  Component _skillChip(String name, String level, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(8),
      ),
      style: Styles(raw: {
        'background': 'linear-gradient(135deg, ${color.value}1F, ${color.value}0D)',
        'border': '1px solid ${color.value}33',
        'display': 'inline-flex',
        'align-items': 'center',
        'gap': '6px',
        'box-sizing': 'border-box',
      }),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(3),
            ),
            style: Styles(raw: {
              'background-color': color.value,
            }),
          ),
          const SizedBox(width: 6),
          CustomText(
            name,
            variant: TextVariant.caption,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          const SizedBox(width: 4),
          CustomText(
            '• $level',
            variant: TextVariant.caption,
            color: color,
            className: 'text-opacity-60',
          ),
        ],
      ),
    );
  }
}
