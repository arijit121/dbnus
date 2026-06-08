import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

class CustomButton extends StatelessComponent {
  final String label;
  final void Function()? onPressed;
  final bool isPrimary;
  final bool isOutlined;
  final bool isSmall;
  final String? icon;
  final String? className;
  final Styles? style;

  const CustomButton({
    required this.label,
    this.onPressed,
    this.isPrimary = true,
    this.isOutlined = false,
    this.isSmall = false,
    this.icon,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final cls = [
      'custom-btn',
      if (isPrimary && !isOutlined) 'btn-primary',
      if (isOutlined) 'btn-outlined',
      if (isSmall) 'btn-sm',
      if (className != null) className!,
    ].join(' ').trim();

    return button(
      classes: cls,
      styles: style,
      events: {'click': (e) => onPressed?.call()},
      [
        if (icon != null) span(classes: 'btn-icon', [text(icon!)]),
        if (label.isNotEmpty) text(label),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-btn', [
      css('&').styles(
        display: .inlineFlex,
        alignItems: .center,
        gap: Gap.all(8.px),
        padding: .symmetric(horizontal: 20.px, vertical: 12.px),
        radius: .all(.circular(10.px)),
        fontSize: 14.px,
        fontWeight: .w600,
        cursor: .pointer,
        transition: Transition('all', duration: Duration(milliseconds: 200)),
        border: .none,
      ),
      css('&.btn-primary').styles(
        backgroundColor: baseHexColor,
        color: Colors.white,
      ),
      css('&.btn-primary:hover').styles(
        backgroundColor: vibrateBlue,
        raw: {'transform': 'translateY(-1px)', 'box-shadow': '0 4px 12px rgba(108, 99, 255, 0.4)'},
      ),
      css('&.btn-outlined').styles(
        raw: {'background-color': 'transparent'},
        color: baseHexColor,
        border: Border.all(color: baseHexColor, width: 1.5.px),
      ),
      css('&.btn-outlined:hover').styles(
        backgroundColor: const Color('#6C63FF10'),
      ),
      css('&.btn-sm').styles(
        padding: .symmetric(horizontal: 14.px, vertical: 8.px),
        fontSize: 12.px,
      ),
    ]),
  ];
}
