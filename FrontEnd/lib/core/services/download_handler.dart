import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' deferred as path_provider;
import 'package:permission_handler/permission_handler.dart';

import 'package:dbnus/core/config/app_config.dart' deferred as app_config;
import 'package:dbnus/core/extensions/logger_extension.dart';
import 'package:dbnus/core/utils/pop_up_items.dart' deferred as pop_up_items;
import 'package:dbnus/core/services/JsService/provider/js_provider.dart';
import 'package:dbnus/core/services/open_service.dart' deferred as open_service;

// import 'package:http/http.dart' as http;
// import 'package:universal_html/html.dart' deferred as html;

class DownloadHandler {
  static const String _group = 'bunchOfFiles';

  static Future<void> download(
      {required String downloadUrl,
      String? fileName,
      bool? inGroup,
      Map<String, String>? headers,
      Map<String, String>? urlQueryParameters}) async {
    try {
      if (kIsWeb) {
        Uri uri = urlQueryParameters?.isNotEmpty == true
            ? Uri.parse(downloadUrl)
                .replace(queryParameters: urlQueryParameters)
            : Uri.parse(downloadUrl);
        await JsProvider.download(
            url: uri.toString(),
            filename: fileName ?? downloadUrl.split("/").last,
            headers: headers);
        /*  String downloadPath = fileName ?? downloadUrl.split("/").last;
        final response = await http.get(uri, headers: headers);

        if (response.statusCode == 200) {
          await html.loadLibrary();
          // Convert the response body into a blob and trigger download
          final blob = html.Blob([response.bodyBytes],
              'application/${downloadPath.split(".").last}');
          final url = html.Url.createObjectUrlFromBlob(blob);

          // Create an anchor element to download the file
          final anchor = html.AnchorElement(href: url)
            ..target = 'blank'
            ..download = downloadPath
            ..click();

          // Revoke the object URL to free memory
          html.Url.revokeObjectUrl(url);
        } else {
          throw Exception(
              'Failed to download file. HTTP ${response.statusCode}');
        }*/
      } else {
        await pop_up_items.loadLibrary();
        pop_up_items.PopUpItems.toastMessage(
            "Downloading ...", Colors.blueAccent);

        if (inGroup == true) {
          // Use .download to start a download and wait for it to complete
          // define the download task (subset of parameters shown)
          await FileDownloader().enqueue(DownloadTask(
            filename:
                '${DateTime.now()}_${fileName ?? downloadUrl.split("/").last}',
            url: downloadUrl,
            directory: await downloadPath(),
            updates: Updates.statusAndProgress,
            retries: 1,
            // request status and progress updates
            group: _group,
            headers: headers,
            urlQueryParameters: urlQueryParameters,
            baseDirectory: BaseDirectory.root,
          ));
          // Use .download to start a download and wait for it to complete
        } else {
          // Start download, and wait for result. Show progress and status changes
          // while downloading
          final result = await FileDownloader().download(DownloadTask(
            filename:
                '${DateTime.now()}_${fileName ?? downloadUrl.split("/").last}',
            url: downloadUrl,
            directory: await downloadPath(),
            updates: Updates.statusAndProgress,
            // request status and progress updates
            retries: 0,
            headers: headers,
            urlQueryParameters: urlQueryParameters,
            baseDirectory: BaseDirectory.root,
          ));
          // Act on the result
          switch (result.status) {
            case TaskStatus.complete:
              String filePath = await result.task.filePath();
              AppLog.i(filePath, tag: "FilePath");
              await open_service.loadLibrary();
              await open_service.OpenService.openFile(filePath);
              AppLog.i('Success!');

            case TaskStatus.canceled:
              AppLog.i('Download was canceled');

            case TaskStatus.paused:
              AppLog.i('Download was paused');

            default:
              AppLog.i('Download not successful');
          }
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<void> config() async {
    await app_config.loadLibrary();
    FileDownloader()
        .registerCallbacks(taskNotificationTapCallback:
            (Task task, NotificationType notificationType) async {
          AppLog.i(
              'Tapped notification $notificationType for taskId ${task.taskId}');
          String filePath = await task.filePath();
          AppLog.i(filePath, tag: "FilePath");
          await open_service.loadLibrary();
          await open_service.OpenService.openFile(filePath);
        })
        .configureNotificationForGroup(FileDownloader.defaultGroup,
            // For the main download button
            // which uses 'enqueue' and a default group
            running: const TaskNotification('Download {filename}',
                'File: {filename} - {progress} - speed {networkSpeed} and {timeRemaining} remaining'),
            complete: const TaskNotification(
                '{displayName} download {filename}', 'Download complete'),
            error: const TaskNotification(
                'Download {filename}', 'Download failed'),
            paused: const TaskNotification(
                'Download {filename}', 'Paused with metadata {metadata}'),
            progressBar: true)
        .configureNotificationForGroup(
          _group, // refers to the Task.group field
          running: const TaskNotification(
              '{numFinished} out of {numTotal}', 'Progress = {progress}'),
          complete: const TaskNotification('Done!', 'Loaded {numTotal} files'),
          error:
              const TaskNotification('Error', '{numFailed}/{numTotal} failed'),
          progressBar: false,
          groupNotificationId:
              '${await app_config.AppConfig().getAppPackageName()}_background_download',
        )
        .configureNotification(
            running: TaskNotification('Downloading', 'file: {filename}'),
            // for the 'Download & Open' dog picture
            // which uses 'download' which is not the .defaultGroup
            // but the .await group so won't use the above config
            complete: const TaskNotification(
                'Download {filename}', 'Download complete'),
            progressBar: true,
            tapOpensFile: true);

    // Use .enqueue for true parallel downloads, i.e. you don't wait for completion of the tasks you
    // enqueue, and can enqueue hundreds of tasks simultaneously.

    // First define an event listener to process `TaskUpdate` events sent to you by the downloader,
    // typically in your app's `initState()`:
    FileDownloader().updates.listen((update) async {
      switch (update) {
        case TaskStatusUpdate():
          // process the TaskStatusUpdate, e.g.
          switch (update.status) {
            case TaskStatus.complete:
              AppLog.i('Task ${update.task.taskId} success!');
              String filePath = await update.task.filePath();
              AppLog.i(filePath, tag: "FilePath");
              await open_service.loadLibrary();
              await open_service.OpenService.openFile(filePath);
            case TaskStatus.canceled:
              AppLog.i('Download was canceled');

            case TaskStatus.paused:
              AppLog.i('Download was paused');

            default:
              AppLog.i('Download not successful');
          }

        case TaskProgressUpdate():
      }
    });
  }

  static Future<String> downloadPath() async {
    try {
      await path_provider.loadLibrary();
      String directoryPath;
      if (Platform.isIOS) {
        directoryPath =
            (await path_provider.getApplicationDocumentsDirectory()).path;
      } else if (Platform.isAndroid) {
        directoryPath =
            (await path_provider.getExternalStorageDirectory())?.path ?? "";
      } else {
        directoryPath =
            (await path_provider.getDownloadsDirectory())?.path ?? "";
      }
      bool dirDownloadExists = await Directory(directoryPath).exists();
      if (!dirDownloadExists) {
        await Directory(directoryPath).create();
      }
      return directoryPath;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return "";
  }

  Future<void> _requestManageExternalStoragePermission() async {
    if (await Permission.storage.isGranted) return;
    final status = await Permission.storage.request();
    if (status.isPermanentlyDenied) {
      await pop_up_items.loadLibrary();
      await pop_up_items.PopUpItems.cupertinoPopup(
        title: "File Permission Required",
        content: "For download file.",
        cancelBtnPresses: () {},
        okBtnPressed: () async {
          await openAppSettings();
        },
      );
    }
  }
}
