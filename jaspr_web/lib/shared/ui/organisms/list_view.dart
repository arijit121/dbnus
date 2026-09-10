import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'layout_types.dart';

export 'layout_types.dart';

class ListView extends StatelessComponent {
  final List<Component>? children;
  final int? itemCount;
  final Component Function(BuildContext context, int index)? itemBuilder;
  final Component Function(BuildContext context, int index)? separatorBuilder;
  final Axis scrollDirection;
  final dynamic padding;
  final dynamic gap;
  final bool shrinkWrap;
  final String? className;
  final Styles? style;

  const ListView({
    required List<Component> this.children,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.gap,
    this.shrinkWrap = false,
    this.className,
    this.style,
    super.key,
  })  : itemCount = null,
        itemBuilder = null,
        separatorBuilder = null;

  const ListView.builder({
    required int this.itemCount,
    required Component Function(BuildContext context, int index) this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.gap,
    this.shrinkWrap = false,
    this.className,
    this.style,
    super.key,
  })  : children = null,
        separatorBuilder = null;

  const ListView.separated({
    required int this.itemCount,
    required Component Function(BuildContext context, int index) this.itemBuilder,
    required Component Function(BuildContext context, int index) this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.gap,
    this.shrinkWrap = false,
    this.className,
    this.style,
    super.key,
  }) : children = null;

  @override
  Component build(BuildContext context) {
    List<Component> resolvedChildren;
    if (children != null) {
      resolvedChildren = children!;
    } else {
      resolvedChildren = [];
      final count = itemCount ?? 0;
      final builder = itemBuilder;
      final separator = separatorBuilder;

      if (builder != null) {
        for (var i = 0; i < count; i++) {
          resolvedChildren.add(builder(context, i));
          if (separator != null && i < count - 1) {
            resolvedChildren.add(separator(context, i));
          }
        }
      }
    }

    return div(
      classes: 'layout-listview ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'display': 'flex',
          'flex-direction': scrollDirection == Axis.vertical ? 'column' : 'row',
          if (scrollDirection == Axis.vertical) 'overflow-y': 'auto' else 'overflow-x': 'auto',
          if (scrollDirection == Axis.vertical) 'overflow-x': 'hidden' else 'overflow-y': 'hidden',
          if (padding != null) 'padding': _mapPadding(padding),
          if (gap != null) 'gap': _mapGap(gap)!,
          if (shrinkWrap) ...{
            if (scrollDirection == Axis.vertical) 'height': 'fit-content' else 'width': 'fit-content',
          } else ...{
            if (scrollDirection == Axis.vertical) 'height': '100%' else 'width': '100%',
          }
        }),
        if (style != null) style!,
      ]),
      resolvedChildren,
    );
  }

  String _mapPadding(dynamic padding) {
    if (padding is num) return '${padding}px';
    return padding.toString();
  }

  String? _mapGap(dynamic gap) {
    if (gap == null) return null;
    if (gap is num) return '${gap}px';
    return gap.toString();
  }

  @css
  static List<StyleRule> get styles => [
        css('.layout-listview').styles(
          raw: {'box-sizing': 'border-box'},
        ),
      ];
}
