import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class PremiumCard extends StatelessComponent {
  final Component child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final bool useGlass;
  final double blur;
  final void Function()? onTap;
  final String? title;
  final String? icon;

  const PremiumCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 20.0,
    this.useGlass = false,
    this.blur = 10.0,
    this.onTap,
    this.title,
    this.icon,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: useGlass ? ColorConst.glassBackground.value : ColorConst.cardBg.value,
        borderRadius: BorderRadius.all(borderRadius),
      ),
      style: Styles(raw: {
        'box-shadow': '0 8px 24px rgba(0,0,0,0.04), 0 2px 8px rgba(0,0,0,0.02)',
        if (useGlass) ...{
          'backdrop-filter': 'blur(${blur}px)',
          '-webkit-backdrop-filter': 'blur(${blur}px)',
          'border': '1.5px solid ${ColorConst.glassBorder.value}',
        },
        if (onTap != null) 'cursor': 'pointer',
        'box-sizing': 'border-box',
        'transition': 'all 0.2s ease',
      }),
      events: onTap != null ? {'click': (e) => onTap!()} : {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    CustomSvgAssetImageView(
                      path: icon!,
                      width: 18,
                      height: 18,
                      color: ColorConst.baseHexColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                  CustomText(
                    title!,
                    variant: TextVariant.h3,
                    fontWeight: FontWeight.w700,
                    color: ColorConst.primaryDark,
                  ),
                ],
              ),
            ),
          Container(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
