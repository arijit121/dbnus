import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../const/color_const.dart';
import 'custom_text.dart';

class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final DecorationImage? image;

  const CustomContainer(
      {super.key,
      this.height,
      this.width,
      this.borderRadius,
      this.color,
      required this.child,
      this.padding,
      this.margin,
      this.borderColor,
      this.boxShadow,
      this.gradient,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
              )
            : null,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        image: image,
      ),
      child: child,
    );
  }
}

class PaginationPullRefreshWidget extends StatefulWidget {
  final Function? paginate;
  final Function? onRefresh;
  final Widget child;

  const PaginationPullRefreshWidget({
    super.key,
    this.paginate,
    this.onRefresh,
    required this.child,
  });

  @override
  State<PaginationPullRefreshWidget> createState() =>
      _PaginationPullRefreshWidgetState();
}

class _PaginationPullRefreshWidgetState
    extends State<PaginationPullRefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
        onNotification: (scrollInfo) {
          /*AppLog.i("Pixels ${scrollInfo.metrics.pixels},"
              "MinScrollExtent ${scrollInfo.metrics.minScrollExtent},"
              "MaxScrollExtent ${scrollInfo.metrics.maxScrollExtent}");*/

          if (scrollInfo.metrics.pixels >=
              ((scrollInfo.metrics.maxScrollExtent +
                      scrollInfo.metrics.minScrollExtent) /
                  2)) {
            if (widget.paginate != null) {
              mounted
                  ? widget.paginate!()
                  : WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        widget.paginate!();
                      }
                    });
            }
          }
          return true;
        },
        child: RefreshIndicator(
            color: ColorConst.baseHexColor,
            backgroundColor: Colors.white,
            onRefresh: () async {
              if (widget.onRefresh != null) {
                widget.onRefresh!();
              }
            },
            child: widget.child));
  }
}

class KeyValueWidget extends StatelessWidget {
  final FontWeight? fontWeight;
  final String keyName;
  final String value;
  final double? size;
  final Color color;

  const KeyValueWidget({
    super.key,
    required this.keyName,
    this.fontWeight,
    required this.value,
    this.size,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(keyName,
            color: color, size: size ?? 16, fontWeight: fontWeight),
        CustomText(
          value,
          color: color,
          size: size ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ],
    );
  }
}
