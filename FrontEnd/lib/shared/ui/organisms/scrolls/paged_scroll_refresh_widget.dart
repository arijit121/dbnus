import 'package:flutter/material.dart';

import '../../../constants/color_const.dart';

class PagedScrollRefreshWidget extends StatefulWidget {
  final Function? paginate, onRefresh, onScroll;
  final Widget child;

  const PagedScrollRefreshWidget({
    super.key,
    this.paginate,
    this.onRefresh,
    this.onScroll,
    required this.child,
  });

  @override
  State<PagedScrollRefreshWidget> createState() =>
      _PagedScrollRefreshWidgetState();
}

class _PagedScrollRefreshWidgetState extends State<PagedScrollRefreshWidget> {
  double _previousScrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: ColorConst.baseHexColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          if (widget.onRefresh != null) {
            widget.onRefresh?.call();
          }
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            widget.onScroll?.call();
            final maxScrollExtent = scrollInfo.metrics.maxScrollExtent;
            final currentScrollPosition = scrollInfo.metrics.pixels;

            if (maxScrollExtent > 0 &&
                currentScrollPosition >= (maxScrollExtent / 4) &&
                currentScrollPosition > _previousScrollPosition) {
              widget.paginate?.call();
            }

            _previousScrollPosition = currentScrollPosition;
            return true;
          },
          child: widget.child,
        ));
  }
}