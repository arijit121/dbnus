import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';
import '../service/context_service.dart';

//ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  LoadingWidget({
    super.key,
    this.height = 300,
    this.width = 300,
    this.backgroundColor = Colors.transparent,
    this.child,
  });

  double width;
  double height;
  Color? backgroundColor;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: width,
      height: height,
      child: child ??
          SpinKitThreeBounce(
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: index.isEven
                        ? HexColor.fromHex(ColorConst.baseHexColor)
                        : HexColor.fromHex(ColorConst.baseHexColor)
                            .withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
              );
            },
            size: 30.0,
          ),
    );
  }
}

void showLoading() {
  showDialog(
    context: CurrentContext().context,
    builder: (context) => Center(
      child: SpinKitThreeBounce(
        itemBuilder: (_, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: index.isEven
                    ? HexColor.fromHex(ColorConst.baseHexColor)
                    : HexColor.fromHex(ColorConst.baseHexColor)
                        .withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
          );
        },
        size: 30.0,
      ),
    ),
    barrierDismissible: false,
  );
}
