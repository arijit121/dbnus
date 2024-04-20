import 'package:flutter/material.dart';

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

  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    required this.child,
    this.padding,
    this.margin,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
              )
            : null,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

class PaginationPullRefreshWidget extends StatelessWidget {
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
            if (paginate != null) {
              paginate!();
            }
          }
          return true;
        },
        child: RefreshIndicator(
            onRefresh: () async {
              if (onRefresh != null) {
                onRefresh!();
              }
            },
            child: child));
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
