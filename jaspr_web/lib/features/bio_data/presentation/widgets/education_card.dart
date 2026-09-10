import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class EducationCard extends StatelessComponent {
  const EducationCard({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          icon: AssetsConst.featherBookOpen,
          title: "Education",
          color: ColorConst.violate,
        ),
        CardShell(
          child: Column(
            children: [
              _educationTile(
                '2017-2021',
                'B. Tech (E.C.E)',
                'UEM, Jaipur',
                AssetsConst.featherAward,
                ColorConst.violate,
              ),
              const CustomDivider(),
              _educationTile(
                '2017',
                'Higher Secondary',
                'Panchgram High School',
                AssetsConst.featherBook,
                ColorConst.lightBlue,
              ),
              const CustomDivider(),
              _educationTile(
                '2015',
                'Secondary',
                'Panchgram High School',
                AssetsConst.featherBookOpen,
                ColorConst.deepGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Component _educationTile(
    String period,
    String degree,
    String school,
    String icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(10),
            ),
            style: Styles(raw: {
              'background-color': '${color.value}1A',
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'center',
            }),
            child: CustomSvgAssetImageView(path: icon, width: 18, height: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  degree,
                  fontWeight: FontWeight.w600,
                  variant: TextVariant.body,
                  color: ColorConst.primaryDark,
                ),
                const SizedBox(height: 2),
                CustomText(
                  school,
                  variant: TextVariant.caption,
                  color: ColorConst.secondaryDark,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(6),
            ),
            style: Styles(raw: {
              'background-color': '${color.value}1A',
            }),
            child: CustomText(
              period,
              variant: TextVariant.caption,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
