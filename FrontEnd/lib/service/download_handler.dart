import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../utils/pop_up_items.dart';
import 'package:path_provider/path_provider.dart';
import '../extension/logger_extension.dart';
import 'JsService/provider/js_provider.dart';
import 'open_service.dart';

class DownloadHandler {
  final String _group = 'bunchOfFiles';
  Future<void> download({required String url, bool? inGroup}) async {
    try {
      if (kIsWeb) {
        await JsProvider().downloadFile(url: url, name: url.split("/").last);
      } else {
        PopUpItems().toastMessage("Downloading ...", Colors.blueAccent);

        if (inGroup == true) {
          // Use .download to start a download and wait for it to complete
          // define the download task (subset of parameters shown)
          await FileDownloader().enqueue(DownloadTask(
              filename: '${DateTime.now()}_${url.split("/").last}',
              url: url,
              directory: await downloadPath(),
              updates: Updates.statusAndProgress,
              retries: 7, // request status and progress updates
              group: _group));
          // Use .download to start a download and wait for it to complete
        } else {
          // Start download, and wait for result. Show progress and status changes
          // while downloading
          final result = await FileDownloader().download(DownloadTask(
            filename: '${DateTime.now()}_${url.split("/").last}',
            url: url,
            directory: await downloadPath(),
            updates: Updates
                .statusAndProgress, // request status and progress updates
            retries: 5,
          ));
          // Act on the result
          switch (result.status) {
            case TaskStatus.complete:
              String filePath = await result.task.filePath();
              AppLog.i(filePath, tag: "FilePath");
              await OpenService().openFile(filePath);
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
    FileDownloader()
        .registerCallbacks(taskNotificationTapCallback:
            (Task task, NotificationType notificationType) async {
          AppLog.i(
              'Tapped notification $notificationType for taskId ${task.taskId}');
          String filePath = await task.filePath();
          AppLog.i(filePath, tag: "FilePath");
          await OpenService().openFile(filePath);
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
              '${await AppConfig().getAppPackageName()}_background_download',
        )
        .configureNotification(
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
              await OpenService().openFile(filePath);
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

  Future<String> downloadPath() async {
    try {
      String directoryPath;
      if (Platform.isIOS) {
        directoryPath = (await getApplicationDocumentsDirectory()).path;
      } else {
        directoryPath = "/storage/emulated/0/Download";

        bool dirDownloadExists = await Directory(directoryPath).exists();
        if (dirDownloadExists) {
          directoryPath = "/storage/emulated/0/Download";
        } else {
          directoryPath = "/storage/emulated/0/Downloads";
        }
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
}
