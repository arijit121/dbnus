import 'package:flutter/material.dart';

import 'custom_text.dart';

Widget customContainer(
        {double? height,
        double? width,
        BorderRadiusGeometry? borderRadius,
        Color? color,
        required Widget? child,
        EdgeInsetsGeometry? padding,
        EdgeInsetsGeometry? margin,
        Color? borderColor,
        List<BoxShadow>? boxShadow}) =>
    Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null
            ? Border.all(
                color: borderColor,
              )
            : null,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: child,
    );

Widget paginationPullRefreshWidget({
  Function? paginate,
  Function? onRefresh,
  required Widget child,
}) =>
    NotificationListener<ScrollEndNotification>(
        onNotification: (scrollInfo) {
          /*AppLog.i("Pixels ${scrollInfo.metrics.pixels},"
              "MinScrollExtent ${scrollInfo.metrics.minScrollExtent},"
              "MaxScrollExtent ${scrollInfo.metrics.maxScrollExtent}");*/

          if (scrollInfo.metrics.pixels >=
              ((scrollInfo.metrics.maxScrollExtent +
                      scrollInfo.metrics.minScrollExtent) /
                  2)) {
            if (paginate != null) {
              paginate();
            }
          }
          return true;
        },
        child: RefreshIndicator(
            onRefresh: () async {
              if (onRefresh != null) {
                onRefresh();
              }
            },
            child: child));

Widget keyValueWidget(
        {required String key,
        FontWeight? fontWeight,
        required String value,
        double? size,
        Color color = Colors.black}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(key, color: color, size: size ?? 16, fontWeight: fontWeight),
        customText(
          value,
          color: color,
          size: size ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ],
    );
