import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class KeyValueWidget extends StatelessComponent {
  final FontWeight? fontWeight;
  final String keyName;
  final String value;
  final Color? color;
  final String? className;

  const KeyValueWidget({
    required this.keyName,
    required this.value,
    this.fontWeight,
    this.color,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Row(
      className: className,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          keyName,
          color: color ?? ColorConst.secondaryDark,
          variant: TextVariant.body,
          fontWeight: fontWeight,
        ),
        CustomText(
          value,
          color: color ?? ColorConst.primaryDark,
          variant: TextVariant.body,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      ],
    );
  }
}
