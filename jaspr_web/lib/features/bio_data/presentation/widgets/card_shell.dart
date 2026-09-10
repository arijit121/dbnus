import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';

class CardShell extends StatelessComponent {
  final Component child;
  final String? className;
  final Styles? style;

  const CardShell({
    required this.child,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: '#FFFFFF',
        borderRadius: BorderRadius.all(14),
      ),
      className: className,
      style: Styles.combine([
        Styles(raw: {
          'box-shadow': '0 2px 10px rgba(0, 0, 0, 0.05)',
          'box-sizing': 'border-box',
          'background-color': ColorConst.cardBg.value,
        }),
        if (style != null) style!,
      ]),
      child: child,
    );
  }
}
