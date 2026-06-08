import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class Wrap extends StatelessComponent {
  final List<Component> children;
  final Axis direction;
  final double spacing;
  final double runSpacing;
  final MainAxisAlignment alignment;
  final String? className;
  final Styles? style;

  const Wrap({
    required this.children,
    this.direction = Axis.horizontal,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.alignment = MainAxisAlignment.start,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-wrap ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'display': 'flex',
          'flex-wrap': 'wrap',
          'flex-direction': direction == Axis.horizontal ? 'row' : 'column',
          'justify-content': _mapMainAxisAlignment(alignment),
          'column-gap': '${spacing}px',
          'row-gap': '${runSpacing}px',
        }),
        if (style != null) style!,
      ]),
      children,
    );
  }

  String _mapMainAxisAlignment(MainAxisAlignment alignment) {
    return switch (alignment) {
      MainAxisAlignment.start => 'flex-start',
      MainAxisAlignment.end => 'flex-end',
      MainAxisAlignment.center => 'center',
      MainAxisAlignment.spaceBetween => 'space-between',
      MainAxisAlignment.spaceAround => 'space-around',
      MainAxisAlignment.spaceEvenly => 'space-evenly',
    };
  }
}
