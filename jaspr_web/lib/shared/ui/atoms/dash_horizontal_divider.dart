import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';

class DashHorizontalDivider extends StatelessComponent {
  final double height;
  final double separatedWidth;
  final Color? color;
  final String? className;

  const DashHorizontalDivider({
    this.height = 1,
    this.separatedWidth = 10,
    this.color,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: className,
      styles: Styles(raw: {
        'width': '100%',
        'height': '0px',
        'border-top': '${height}px dashed ${(color ?? ColorConst.primaryDark).value}',
        'background': 'none',
      }),
      [],
    );
  }
}
