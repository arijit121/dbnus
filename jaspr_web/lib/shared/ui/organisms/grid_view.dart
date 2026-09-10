import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class GridView extends StatelessComponent {
  final List<Component>? children;
  final int? itemCount;
  final Component Function(BuildContext context, int index)? itemBuilder;
  final int? crossAxisCount;
  final double? maxCrossAxisExtent;
  final double? childAspectRatio;
  final dynamic padding;
  final dynamic mainAxisSpacing;
  final dynamic crossAxisSpacing;
  final String? className;
  final Styles? style;
  final bool shrinkWrap;

  const GridView({
    required List<Component> this.children,
    this.crossAxisCount,
    this.maxCrossAxisExtent,
    this.childAspectRatio,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.className,
    this.style,
    this.shrinkWrap = false,
    super.key,
  })  : itemCount = null,
        itemBuilder = null;

  const GridView.builder({
    required int this.itemCount,
    required Component Function(BuildContext context, int index) this.itemBuilder,
    this.crossAxisCount,
    this.maxCrossAxisExtent,
    this.childAspectRatio,
    this.padding,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.className,
    this.style,
    this.shrinkWrap = false,
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
      if (builder != null) {
        for (var i = 0; i < count; i++) {
          resolvedChildren.add(builder(context, i));
        }
      }
    }

    String gridTemplateColumns;
    if (crossAxisCount != null) {
      gridTemplateColumns = 'repeat($crossAxisCount, 1fr)';
    } else if (maxCrossAxisExtent != null) {
      gridTemplateColumns = 'repeat(auto-fill, minmax(${maxCrossAxisExtent}px, 1fr))';
    } else {
      gridTemplateColumns = 'repeat(2, 1fr)';
    }

    final rowSpacing = _mapSpacing(mainAxisSpacing ?? 0);
    final colSpacing = _mapSpacing(crossAxisSpacing ?? 0);

    return div(
      classes: 'layout-gridview ${className ?? ''}'.trim(),
      styles: Styles.combine([
        Styles(raw: {
          'grid-template-columns': gridTemplateColumns,
          'row-gap': rowSpacing,
          'column-gap': colSpacing,
          if (padding != null) 'padding': _mapSpacing(padding),
          if (childAspectRatio != null) '--child-aspect-ratio': '$childAspectRatio',
          if (shrinkWrap) 'height': 'fit-content' else 'height': '100%',
          'overflow-y': shrinkWrap ? 'visible' : 'auto',
        }),
        if (style != null) style!,
      ]),
      resolvedChildren,
    );
  }

  String _mapSpacing(dynamic val) {
    if (val is num) return '${val}px';
    return val.toString();
  }

  @css
  static List<StyleRule> get styles => [
        css('.layout-gridview').styles(
          display: .grid,
          raw: {'box-sizing': 'border-box'},
        ),
        css('.layout-gridview > *').styles(
          raw: {'aspect-ratio': 'var(--child-aspect-ratio, auto)'},
        ),
      ];
}
