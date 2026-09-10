import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../ui.dart';

class CustomTabBar extends StatelessComponent {
  final Color inactiveColor;
  final Color activeColor;
  final String title;
  final bool isActive;
  final void Function()? onPressed;
  final String? className;

  const CustomTabBar({
    required this.inactiveColor,
    required this.activeColor,
    required this.title,
    required this.isActive,
    this.onPressed,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return CustomTextButton(
      className: className,
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            title,
            color: isActive ? activeColor : inactiveColor,
            variant: TextVariant.body,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
          const SizedBox(height: 7),
          Container(
            width: (title.length * 8.0) + 9.0,
            height: 2,
            style: Styles(raw: {
              'background-color': isActive ? activeColor.value : 'transparent',
              'border-radius': '10px',
              'transition': 'all 0.2s ease',
            }),
          ),
        ],
      ),
    );
  }
}
