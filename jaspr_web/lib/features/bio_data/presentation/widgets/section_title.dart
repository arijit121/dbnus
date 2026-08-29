import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';

class SectionTitle extends StatelessComponent {
  final String icon;
  final String title;
  final Color color;

  const SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
          const SizedBox(width: 12),
          Expanded(
            child: CustomText(
              title,
              fontWeight: FontWeight.w700,
              variant: TextVariant.h3,
              color: ColorConst.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
