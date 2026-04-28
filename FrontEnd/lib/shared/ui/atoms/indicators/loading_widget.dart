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

/// Displays a global, non-dismissible loading dialog.
///
/// This dialog prevents user interactions while it is visible. It returns
/// a [Future] that resolves to the [BuildContext] of the displayed dialog.
/// You can pass this context to [hideLoading] to explicitly close the dialog.
///
/// **Example Usage:**
/// ```dart
/// // Show the loading indicator before starting an async task
/// final dialogContext = await showLoading();
/// 
/// try {
///   // Perform a long-running operation...
///   await fetchSomeData();
/// } finally {
///   // Safely hide the loading dialog when finished
///   hideLoading(loadingDialogContext: dialogContext);
/// }
/// ```
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

/// Hides the currently visible global loading dialog.
///
/// If [loadingDialogContext] is provided, it uses that specific context to
/// close the dialog. Otherwise, it falls back to the current global context
/// and pops the route specifically matching the `global_loading_dialog` name.
///
/// **Example Usage:**
/// ```dart
/// // 1. Hiding without a specific context (uses global context):
/// showLoading();
/// await performTask();
/// hideLoading(); 
///
/// // 2. Hiding with a specific context:
/// final dialogContext = await showLoading();
/// await performTask();
/// hideLoading(loadingDialogContext: dialogContext);
/// ```
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
