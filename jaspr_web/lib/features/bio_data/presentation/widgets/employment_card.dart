import 'package:jaspr/dom.dart' hide BorderRadius, Padding;
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'section_title.dart';

class EmploymentCard extends StatelessComponent {
  const EmploymentCard({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          icon: AssetsConst.featherBriefcase,
          title: "Employment History",
          color: Color('#E67E22'),
        ),
        GridView(
          maxCrossAxisExtent: 340,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          children: [
            _jobCard(
              'Mar 2023 - Present',
              'App Developer',
              'SastaSundar, Kolkata',
              'App & Web Developer (Flutter), specializing in crafting seamless cross-platform solutions.',
              const [Color('#E67E22'), Color('#D35400')],
              true,
            ),
            _jobCard(
              'May 2022 - Mar 2023',
              'Software Engineer',
              'Max Mobility, Kolkata',
              'Skilled in Dart, crafting cross-platform apps. Proficient in BLoC & GetX state management.',
              const [ColorConst.lightBlue, ColorConst.deepBlue],
              false,
            ),
            _jobCard(
              'Oct 2021 - Apr 2022',
              'Flutter Developer',
              'SOFTWEBIAN',
              'Specialize in crafting cross-platform apps with Dart. Proficient in UI/UX & API integration.',
              const [ColorConst.violate, ColorConst.sidebarSelected],
              false,
            ),
            _jobCard(
              'Nov 2020 - May 2021',
              'Trainee Developer',
              'MOBILOITTE, New Delhi',
              'Mastering Java, Kotlin, Dart & Flutter for cross-platform apps.',
              const [ColorConst.deepGreen, Color('#1B7A4D')],
              false,
            ),
          ],
        ),
      ],
    );
  }

  Component _jobCard(
    String period,
    String title,
    String company,
    String description,
    List<Color> gradient,
    bool isCurrent,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: '#FFFFFF',
        borderRadius: BorderRadius.all(14),
      ),
      style: Styles(raw: {
        'box-shadow': '0 2px 10px rgba(0, 0, 0, 0.05)',
        'overflow': 'hidden',
        'display': 'flex',
        'flex-direction': 'column',
        'box-sizing': 'border-box',
        'background-color': ColorConst.cardBg.value,
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient top bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            style: Styles(raw: {
              'background': 'linear-gradient(135deg, ${gradient.first.value}, ${gradient.last.value})',
              'display': 'flex',
              'align-items': 'center',
              'box-sizing': 'border-box',
            }),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSvgAssetImageView(
                  path: isCurrent
                      ? AssetsConst.featherZap
                      : AssetsConst.featherClock,
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomText(
                    period,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    variant: TextVariant.caption,
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(6),
                    ),
                    style: Styles(raw: {
                      'background-color': 'rgba(255, 255, 255, 0.25)',
                    }),
                    child: const CustomText(
                      "Current",
                      color: Colors.white,
                      variant: TextVariant.label,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontWeight: FontWeight.w700,
                  variant: TextVariant.body,
                  color: ColorConst.primaryDark,
                ),
                const SizedBox(height: 4),
                CustomText(
                  company,
                  variant: TextVariant.bodySmall,
                  color: ColorConst.secondaryDark,
                  className: 'italic-text',
                ),
                const SizedBox(height: 10),
                CustomText(
                  description,
                  variant: TextVariant.bodySmall,
                  color: ColorConst.secondaryDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
