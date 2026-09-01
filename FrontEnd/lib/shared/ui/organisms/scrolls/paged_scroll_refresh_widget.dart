import 'package:material_ui/material_ui.dart';

import '../../../constants/color_const.dart';

class PagedScrollRefreshWidget extends StatefulWidget {
  final Function? paginate, onRefresh;
  final Widget child;
  final Axis paginationAxis;
  final Function(ScrollNotification)? onScroll;

  const PagedScrollRefreshWidget({
    super.key,
    this.paginate,
    this.onRefresh,
    this.onScroll,
    required this.child,
    this.paginationAxis = Axis.vertical,
  });

  @override
  State<PagedScrollRefreshWidget> createState() =>
      _PagedScrollRefreshWidgetState();
}

class _PagedScrollRefreshWidgetState extends State<PagedScrollRefreshWidget> {
  double _previousScrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        // 🔐 SAFETY #1 — avoid callbacks after dispose
        if (!mounted) return false;

        final metrics = scrollInfo.metrics;

        if (metrics.axis != widget.paginationAxis) return false;

        if (widget.onScroll != null) {
          widget.onScroll!(scrollInfo);
        }

        // 🔐 SAFETY #2 — protect against negative or invalid metrics
        if (metrics.maxScrollExtent <= 0) return false;

        final maxScrollExtent = metrics.maxScrollExtent;
        final currentScrollPosition = metrics.pixels;

        if (maxScrollExtent > 0 &&
            currentScrollPosition >= (maxScrollExtent / 4) &&
            currentScrollPosition > _previousScrollPosition) {
          // 🔐 SAFETY #3 — schedule microtask so pagination does not fire inside scroll callbacks
          Future.microtask(() {
            if (mounted) widget.paginate?.call();
          });
        }

        _previousScrollPosition = currentScrollPosition;
        return true;
      },
      child: RefreshIndicator(
        color: ColorConst.baseHexColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          if (widget.onRefresh != null) {
            widget.onRefresh?.call();
          }
        },
        child: widget.child,
      ),
    );
  }
}
