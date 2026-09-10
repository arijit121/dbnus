import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_app/shared/constants/theme.dart';
import 'package:jaspr_app/shared/ui/ui.dart';

class SectionTitle extends StatelessComponent {
  final String title;
  final String icon;
  final Component? trailing;

  const SectionTitle({
    required this.title,
    required this.icon,
    this.trailing,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Accent bar
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          style: Styles(raw: {
            'background': 'linear-gradient(to bottom, ${violate.value}, ${sidebarSelected.value})',
          }),
        ),
        const SizedBox(width: 10),
        // Icon with soft background circle
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: '${violate.value}1A', // 10% opacity hex
            borderRadius: BorderRadius.circular(999), // Circle
          ),
          child: img(
            src: icon,
            styles: Styles(raw: {'width': '18px', 'height': '18px'}),
          ),
        ),
        const SizedBox(width: 10),
        // Title text
        Expanded(
          child: CustomText(
            title,
            fontWeight: FontWeight.w700,
            variant: TextVariant.h3,
            color: primaryDark,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
