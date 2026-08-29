import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/assects_const.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class CustomExpansionTile extends StatefulComponent {
  final Component? leading;
  final Component? title;
  final Component? subtitle;
  final Component? activeTrailing;
  final Component? inActiveTrailing;
  final List<Component>? children;
  final bool isExpanded;
  final EdgeInsets? tilePadding;
  final EdgeInsets? childrenPadding;
  final String? className;

  const CustomExpansionTile({
    this.leading,
    this.title,
    this.subtitle,
    this.activeTrailing,
    this.inActiveTrailing,
    this.children,
    this.isExpanded = false,
    this.tilePadding,
    this.childrenPadding,
    this.className,
    super.key,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = component.isExpanded;
  }

  @override
  Component build(BuildContext context) {
    return Container(
      className: component.className,
      style: Styles(raw: {
        'width': '100%',
        'border-radius': '8px',
        'overflow': 'hidden',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header tile
          div(
            events: {
              'click': (e) {
                setState(() => _expanded = !_expanded);
              }
            },
            styles: Styles(raw: {
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'space-between',
              'padding': component.tilePadding?.toString() ?? '12px 16px',
              'cursor': 'pointer',
              'user-select': 'none',
              'background-color': '#FFFFFF',
            }),
            [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (component.leading != null) ...[
                    component.leading!,
                    const SizedBox(width: 12),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (component.title != null) component.title!,
                      if (component.subtitle != null) ...[
                        const SizedBox(height: 2),
                        component.subtitle!,
                      ],
                    ],
                  ),
                ],
              ),
              _expanded
                  ? (component.activeTrailing ??
                      const CustomSvgAssetImageView(
                        path: AssetsConst.featherChevronRight,
                        width: 16,
                        height: 16,
                        color: ColorConst.grey,
                      ))
                  : (component.inActiveTrailing ??
                      const CustomSvgAssetImageView(
                        path: AssetsConst.featherChevronRight,
                        width: 16,
                        height: 16,
                        color: ColorConst.grey,
                      )),
            ],
          ),
          // Expanded body
          if (_expanded && component.children != null && component.children!.isNotEmpty)
            Container(
              padding: component.childrenPadding ?? const EdgeInsets.all(16),
              style: Styles(raw: {
                'width': '100%',
                'box-sizing': 'border-box',
                'background-color': '#FFFFFF',
                'border-top': '1px solid ${ColorConst.lineGrey.value}',
              }),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: component.children!,
              ),
            ),
        ],
      ),
    );
  }
}
