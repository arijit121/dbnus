import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class Column extends StatelessComponent {
  final List<Component> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final num? gap;
  final String? className;
  final Styles? style;

  const Column({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.gap,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'layout-column ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(
          raw: {
            'justify-content': _mapMainAxisAlignment(mainAxisAlignment),
            'align-items': _mapCrossAxisAlignment(crossAxisAlignment),
            if (gap != null) 'gap': _mapGap(gap)!,
            if (mainAxisSize == MainAxisSize.max) 'height': '100%',
            if (mainAxisSize == MainAxisSize.min) 'height': 'fit-content',
          },
        ),
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

  String _mapCrossAxisAlignment(CrossAxisAlignment alignment) {
    return switch (alignment) {
      CrossAxisAlignment.start => 'flex-start',
      CrossAxisAlignment.end => 'flex-end',
      CrossAxisAlignment.center => 'center',
      CrossAxisAlignment.stretch => 'stretch',
      CrossAxisAlignment.baseline => 'baseline',
    };
  }

  String? _mapGap(dynamic gap) {
    if (gap == null) return null;
    if (gap is num) return '${gap}px';
    return gap.toString();
  }

  @css
  static List<StyleRule> get styles => [
    css('.layout-column').styles(
      display: .flex,
      flexDirection: .column,
    ),
  ];
}
