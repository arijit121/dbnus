import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../service/value_handler.dart';
import '../utils/pop_up_items.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../extension/logger_extension.dart';
import 'JsService/provider/js_provider.dart';

class DownloadHandler {
  Future<void> download({required String url}) async {
    try {
      if (kIsWeb) {
        await JsProvider().downloadFile(url: url, name: url.split("/").last);
      } else {
        PopUpItems().toastMessage("Downloading ...", Colors.blueAccent);
        _bindBackgroundIsolate();
        await FlutterDownloader.registerCallback(downloadCallback, step: 1);
        final taskId = await FlutterDownloader.enqueue(
            url: url,
            savedDir: await downloadPath(),
            showNotification: true,
            // show download progress in status bar (for Android)
            openFileFromNotification: true,
            // click on notification to open downloaded file (for Android),
            saveInPublicStorage: true);

        AppLog.i(taskId, tag: "TaskId");
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  Future<String> downloadPath() async {
    try {
      String directoryPath;
      if (Platform.isIOS) {
        directoryPath = (await getApplicationDocumentsDirectory()).path ?? "";
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

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) async {
    AppLog.i('task ($id) is in status ($status) and process ($progress)',
        tag: 'Callback on background isolate');
    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  void _bindBackgroundIsolate() {
    List<TaskInfo>? _tasks;
    ReceivePort _port = ReceivePort();
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;
      // var v = await FlutterDownloader.loadTasks();
      AppLog.i('task ($taskId) is in status ($status) and process ($progress)',
          tag: 'Callback on UI isolate:');

      if (progress == 100) {
        String query = "SELECT * FROM task WHERE task_id='$taskId'";
        List<DownloadTask>? tasks =
            await FlutterDownloader.loadTasksWithRawQuery(query: query);

        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        await Permission.accessMediaLocation.request();
        await OpenFilex.open(
            "${tasks?.first.savedDir ?? ""}/${tasks?.first.filename ?? ""}");
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}
