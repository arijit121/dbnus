import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../const/color_const.dart';
import '../data/model/service_model.dart';
import '../extension/hex_color.dart';
import '../storage/localCart/bloc/local_cart_bloc.dart';
import '../storage/localCart/repo/local_cart_repo.dart';
import 'custom_text.dart';

Widget customCardDesign(
        {Size? minimumSize,
        double? radius,
        Color? color,
        required Widget? child,
        EdgeInsetsGeometry? padding,
        Color? borderColor,
        List<BoxShadow>? boxShadow}) =>
    Container(
      height: minimumSize?.height,
      width: minimumSize?.width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        border: borderColor != null
            ? Border.all(
                color: borderColor,
              )
            : null,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
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
        customText(key, color, size ?? 16, fontWeight: fontWeight),
        customText(
          value,
          color,
          size ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ],
    );

Widget conflictedTestMsg(
    {ServiceModel? serviceModel, bool? fullLengthDisableMsg}) {
  return BlocBuilder<LocalCartBloc, LocalCartState>(
    builder: (context, state) {
      if (!LocalCartRepo().checkIfServiceContainInCart(
              allServiceList: state.serviceList.value ?? [],
              serviceId: "${serviceModel?.serviceId}") &&
          LocalCartRepo().checkIfPackageServiceContainInCart(
              allServiceList: state.serviceList.value ?? [],
              serviceModel: serviceModel)) {
        return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: customCardDesign(
              radius: 5,
              color: Colors.orangeAccent,
              minimumSize:
                  fullLengthDisableMsg == true ? null : const Size(167, 40),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              child: customText(
                serviceModel?.isPackage == true
                    ? "This package have test(s) already in cart."
                    : "Already in cart under selected package.",
                HexColor.fromHex(ColorConst.primaryDark),
                13,
              ),
            ));
      }
      return Container();
    },
  );
}
