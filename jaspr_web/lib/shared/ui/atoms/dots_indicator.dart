import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';
import '../organisms/layout_types.dart';

class DotsIndicator extends StatelessComponent {
  final int dotsCount;
  final int position;
  final DotsDecorator decorator;
  final Axis axis;
  final bool reversed;
  final void Function(int position)? onTap;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final String? className;

  const DotsIndicator({
    required this.dotsCount,
    this.position = 0,
    this.decorator = const DotsDecorator(),
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final dotsList = List<Component>.generate(
      dotsCount,
      (index) => _buildDot(index),
    );
    final dots = reversed ? dotsList.reversed.toList() : dotsList;

    return div(
      classes: className,
      styles: Styles(raw: {
        'display': 'flex',
        'flex-direction': axis == Axis.horizontal ? 'row' : 'column',
        'justify-content': mainAxisAlignment == MainAxisAlignment.center
            ? 'center'
            : mainAxisAlignment == MainAxisAlignment.start
                ? 'flex-start'
                : 'flex-end',
        'align-items': 'center',
      }),
      dots,
    );
  }

  Component _buildDot(int index) {
    final isActive = position == index;
    final dotColor = isActive ? decorator.activeColor : decorator.color;
    final dotSize = isActive ? decorator.activeSize : decorator.size;
    final isCircular = decorator.shape == DotShape.circle;

    return div(
      events: onTap != null ? {'click': (e) => onTap!(index)} : {},
      styles: Styles(raw: {
        'width': '${dotSize}px',
        'height': '${dotSize}px',
        'margin': decorator.spacing.toString(),
        'background-color': dotColor.value,
        'border-radius': isCircular ? '50%' : '${decorator.borderRadius}px',
        'transition': 'all 0.2s ease',
        if (onTap != null) 'cursor': 'pointer',
      }),
      [],
    );
  }
}

enum DotShape { circle, roundedRectangle }

class DotsDecorator {
  final Color color;
  final Color activeColor;
  final double size;
  final double activeSize;
  final DotShape shape;
  final double borderRadius;
  final EdgeInsets spacing;

  const DotsDecorator({
    this.color = ColorConst.grey,
    this.activeColor = ColorConst.baseHexColor,
    this.size = 9.0,
    this.activeSize = 9.0,
    this.shape = DotShape.circle,
    this.borderRadius = 4.0,
    this.spacing = const EdgeInsets.all(6.0),
  });
}
