import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;
import '../models/custom_file.dart';
import '../../shared/extensions/logger_extension.dart';

class CustomFilePicker {
  static Future<CustomFile?> pickSingleFile({List<String>? allowedExtensions}) async {
    try {
      final completer = Completer<CustomFile?>();
      final input = web.document.createElement('input') as web.HTMLInputElement;
      input.type = 'file';
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        input.accept = allowedExtensions.map((e) => '.$e').join(',');
      }

      input.onchange = (web.Event e) async {
        final files = input.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = web.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onloadend = (web.Event e) {
            final result = reader.result;
            if (result != null) {
              final arrayBuffer = result as JSArrayBuffer;
              final byteBuffer = arrayBuffer.toDart;
              completer.complete(CustomFile(
                name: file.name,
                bytes: Uint8List.view(byteBuffer),
              ));
            } else {
              completer.complete(null);
            }
          }.toJS;
        } else {
          completer.complete(null);
        }
      }.toJS;

      input.click();
      return completer.future;
    } catch (e) {
      AppLog.e(e);
    }
    return null;
  }

  static Future<List<CustomFile>?> pickMultipleFile({List<String>? allowedExtensions}) async {
    try {
      final completer = Completer<List<CustomFile>?>();
      final input = web.document.createElement('input') as web.HTMLInputElement;
      input.type = 'file';
      input.multiple = true;
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        input.accept = allowedExtensions.map((e) => '.$e').join(',');
      }

      input.onchange = (web.Event e) async {
        final files = input.files;
        if (files != null && files.length > 0) {
          final customFiles = <CustomFile>[];
          int loadedCount = 0;

          for (int i = 0; i < files.length; i++) {
            final file = files.item(i)!;
            final reader = web.FileReader();
            reader.readAsArrayBuffer(file);
            reader.onloadend = (web.Event e) {
              final result = reader.result;
              if (result != null) {
                final arrayBuffer = result as JSArrayBuffer;
                final byteBuffer = arrayBuffer.toDart;
                customFiles.add(CustomFile(
                  name: file.name,
                  bytes: Uint8List.view(byteBuffer),
                ));
              }
              loadedCount++;
              if (loadedCount == files.length) {
                completer.complete(customFiles);
              }
            }.toJS;
          }
        } else {
          completer.complete(null);
        }
      }.toJS;

      input.click();
      return completer.future;
    } catch (e) {
      AppLog.e(e);
    }
    return null;
  }

  static Future<CustomFile?> cameraPicker() async {
    try {
      final completer = Completer<CustomFile?>();
      final input = web.document.createElement('input') as web.HTMLInputElement;
      input.type = 'file';
      input.accept = 'image/*';
      input.setAttribute('capture', 'environment');

      input.onchange = (web.Event e) async {
        final files = input.files;
        if (files != null && files.length > 0) {
          final file = files.item(0)!;
          final reader = web.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onloadend = (web.Event e) {
            final result = reader.result;
            if (result != null) {
              final arrayBuffer = result as JSArrayBuffer;
              final byteBuffer = arrayBuffer.toDart;
              completer.complete(CustomFile(
                name: file.name,
                bytes: Uint8List.view(byteBuffer),
              ));
            } else {
              completer.complete(null);
            }
          }.toJS;
        } else {
          completer.complete(null);
        }
      }.toJS;

      input.click();
      return completer.future;
    } catch (e) {
      AppLog.e(e);
    }
    return null;
  }

  static Future<CustomFile?> galleryPicker() async {
    return pickSingleFile(allowedExtensions: ['jpg', 'jpeg', 'png']);
  }

  static Future<CustomFile?> customFilePicker({bool? noDocs, bool? noCamera}) async {
    if (noDocs == true) {
      return galleryPicker();
    }
    return pickSingleFile();
  }
}
