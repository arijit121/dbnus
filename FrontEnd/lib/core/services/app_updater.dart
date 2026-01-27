import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/open_service.dart';

class AppUpdater {
  static Future<void> startUpdate({bool? isForceUpdate}) async {
    try {
      if (Platform.isIOS) {
        AppUpdater._checkAndUpdateIos(isForceUpdate: isForceUpdate);
      } else if (Platform.isAndroid) {
        isForceUpdate == true
            ? AppUpdater._checkForImmediateUpdateAndUpdate()
            : AppUpdater._checkForFlexibleUpdateAndUpdate();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  /// Returns `true` if the store version of the application is greater than the local version.
  static bool _canUpdate(
      {required String storeVersion, required String localVersion}) {
    final local = localVersion.split('.').map(int.parse).toList();
    final store = storeVersion.split('.').map(int.parse).toList();

    // Each consecutive field in the version notation is less significant than the previous one,
    // therefore only one comparison needs to yield `true` for it to be determined that the store
    // version is greater than the local version.
    for (var i = 0; i < store.length; i++) {
      // The store version field is newer than the local version.
      if (store[i] > local[i]) {
        return true;
      }

      // The local version field is newer than the store version.
      if (local[i] > store[i]) {
        return false;
      }
    }

    // The local and store versions are the same.
    return false;
  }

  static Future<void> _checkAndUpdateIos({bool? isForceUpdate}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final newVersion = NewVersionPlus(
        iOSId: packageInfo.packageName, iOSAppStoreCountry: "us");
    final response = await newVersion.getVersionStatus();

    if (response != null) {
      String? storeVersion = response.storeVersion;
      String? appStoreListingURL = response.appStoreLink;
      String localVersion = packageInfo.version;
      BuildContext context = CurrentContext().context;
      if (AppUpdater._canUpdate(
              storeVersion: storeVersion ?? "", localVersion: localVersion) &&
          context.mounted) {
        String? result = await showDialog<String>(
          context: context,
          builder: (BuildContext context) => CupertinoTheme(
            data: const CupertinoThemeData(brightness: Brightness.light),
            child: CupertinoAlertDialog(
              title: CustomText(TextUtils.update_app,
                  color: ColorConst.primaryDark,
                  size: 16,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold),
              content: Column(
                children: [
                  CustomText(
                    TextUtils.update_msg
                        .replaceAll("{{appName}}", packageInfo.appName)
                        .replaceAll(
                            "{{currentAppStoreVersion}}", storeVersion ?? "")
                        .replaceAll(
                            "{{currentInstalledVersion}}", localVersion),
                    color: ColorConst.primaryDark,
                    size: 12,
                  ),
                ],
              ),
              actions: <Widget>[
                CustomTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: CustomText(
                        isForceUpdate == true ? "Cancel" : "Ignore",
                        color: Colors.blue,
                        size: 13)),
                CustomTextButton(
                    onPressed: () {
                      Navigator.pop(context, "Y");
                    },
                    child: const CustomText("Update Now",
                        color: Colors.blue, size: 13)),
              ],
            ),
          ),
        );
        if (result == "Y") {
          OpenService.openUrl(uri: Uri.parse(appStoreListingURL ?? ""));
        } else if (isForceUpdate == true) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      }
    }
  }

  static Future<void> _checkForFlexibleUpdateAndUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            InAppUpdate.completeFlexibleUpdate().then((_) {
              AppLog.i("Success!");
            }).catchError((e, s) {
              AppLog.e(e.toString(), stackTrace: s);
            });
          }
        }).catchError((e, s) {
          AppLog.e(e.toString(), stackTrace: s);
        });
      }
    }).catchError((e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    });
  }

  static Future<void> _checkForImmediateUpdateAndUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().then((onValue) async {
          if (onValue == AppUpdateResult.userDeniedUpdate) {
            await SystemNavigator.pop();
          }
        }).catchError((e, s) {
          AppLog.e(e.toString(), stackTrace: s);
        });
      }
    }).catchError((e, s) {
      AppLog.e(e.toString(), stackTrace: s);
    });
  }
}
