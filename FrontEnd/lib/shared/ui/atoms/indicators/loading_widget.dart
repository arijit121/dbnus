import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/services/context_service.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.height = 300,
    this.width = 300,
    this.backgroundColor = Colors.transparent,
    this.child,
  });

  final double width;
  final double height;
  final Color? backgroundColor;
  final Widget? child;

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
                        ? ColorConst.baseHexColor
                        : ColorConst.baseHexColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
              );
            },
            size: 30.0,
          ),
    );
  }
}

/// shows loading dialog and return the context of the dialog 
Future<BuildContext> showLoading() {
  Completer<BuildContext> dialogCompleter = Completer<BuildContext>();

  showDialog(
    context: CurrentContext().context,
    barrierDismissible: false,
    routeSettings: RouteSettings(name: "global_loading_dialog"),
    builder: (context) {
      if (!dialogCompleter.isCompleted) {
        dialogCompleter.complete(context);
      }

      return Center(
        child: SpinKitThreeBounce(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                  color: index.isEven
                      ? ColorConst.baseHexColor
                      : ColorConst.baseHexColor.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
            );
          },
          size: 30.0,
        ),
      );
    },
  );
  return dialogCompleter.future;
}

/// Hides loading dialog  
void hideLoading({BuildContext? loadingDialogContext}) {
  final context = loadingDialogContext ?? CurrentContext().context;
  if (context.mounted && Navigator.canPop(context)) {
    Navigator.popUntil(
      context,
      (route) {
        if (route.settings.name == "global_loading_dialog") {
          Navigator.pop(context);
        }
        return true;
      },
    );
  }
}
