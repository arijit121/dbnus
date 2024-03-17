import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extension/spacing.dart';
import '../service/open_url_service.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../const/color_const.dart';
import '../extension/hex_color.dart';
import '../extension/logger_extension.dart';
import '../utils/text_utils.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';
import 'context_service.dart';

class AppUpdater {
  Future<void> startUpdate() async {
    try {
      if (Platform.isIOS) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final iTunes = ITunesSearchAPI();
        final response =
            await (iTunes.lookupByBundleId(packageInfo.packageName));
        if (response != null) {
          String? storeVersion = iTunes.version(response);
          String? appStoreListingURL = iTunes.trackViewUrl(response);
          String? releaseNotes = iTunes.releaseNotes(response);
          String localVersion = packageInfo.version;
          BuildContext context = CurrentContext().context;
          if (_canUpdate(
                  storeVersion: storeVersion ?? "",
                  localVersion: localVersion) &&
              context.mounted) {
            String? result = await showDialog<String>(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: customText(TextUtils.update_app,
                    color: HexColor.fromHex(ColorConst.primaryDark),
                    size: 16,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold),
                content: Column(
                  children: [
                    customText(
                      TextUtils.update_msg
                          .replaceAll("{{appName}}", packageInfo.appName)
                          .replaceAll(
                              "{{currentAppStoreVersion}}", localVersion)
                          .replaceAll("{{currentInstalledVersion}}",
                              storeVersion ?? ""),
                      color: HexColor.fromHex(ColorConst.primaryDark),
                      size: 12,
                    ),
                    8.ph,
                    customText(TextUtils.release_notes,
                        color: HexColor.fromHex(ColorConst.primaryDark),
                        size: 14,
                        fontWeight: FontWeight.bold),
                    5.ph,
                    customText(
                      releaseNotes ?? "",
                      color: HexColor.fromHex(ColorConst.primaryDark),
                      size: 13,
                    ),
                  ],
                ),
                actions: <Widget>[
                  customTextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          customText("Ignore", color: Colors.blue, size: 13)),
                  customTextButton(
                      onPressed: () {
                        Navigator.pop(context, "Y");
                      },
                      child: customText("Update Now",
                          color: Colors.blue, size: 13)),
                ],
              ),
            );
            if (result == "Y") {
              OpenUrlService()
                  .openUrl(uri: Uri.parse(appStoreListingURL ?? ""));
            }
          }
        }
      } else if (Platform.isAndroid) {
        _checkForFlexibleUpdateAndUpdate();
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  /// Returns `true` if the store version of the application is greater than the local version.
  bool _canUpdate(
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

  Future<void> _checkForFlexibleUpdateAndUpdate() async {
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

  Future<void> _checkForImmediateUpdateAndUpdate() async {
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
