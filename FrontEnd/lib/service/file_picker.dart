import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../const/color_const.dart';
import '../data/model/custom_file.dart';
import '../extension/logger_extension.dart';
import '../extension/spacing.dart';
import '../service/context_service.dart';
import '../utils/pop_up_items.dart';
import '../widget/custom_text.dart';
import '../widget/loading_widget.dart';
import 'JsService/provider/js_provider.dart';

class CustomFilePicker {
  final int _maxFileSize = 5;
  final String _notJpgErrorMsg =
      "Invalid file format. Please select an image in JPG format";

  Future<CustomFile?> pickSingleFile({List<String>? allowedExtensions}) async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        final permissionStatus = await _fileManagerPermission(
            permission: Permission.storage, name: 'File');
        if (!permissionStatus.isGranted) {
          return null;
        }
      }

      List<String> _allowedExtensions =
          allowedExtensions ?? ['jpeg', 'jpg', 'pdf'];
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
      );

      if (result != null) {
        PlatformFile platformFile = result.files.single;
        int sizeInBytes = platformFile.size;
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (!_allowedExtensions.contains(platformFile.extension)) {
          PopUpItems().toastMessage("Invalid file type.", ColorConst.red,
              durationSeconds: 4);
        } else if (platformFile.extension == 'jpg' ||
            platformFile.extension == 'jpeg') {
          CustomFile? compressFile = await _compressAndResizeImage(CustomFile(
            name: platformFile.name,
            path: kIsWeb ? null : platformFile.path,
            bytes: platformFile.bytes,
          ));
          if (compressFile != null) {
            return CustomFile(
              name: compressFile.name,
              path: kIsWeb ? null : compressFile.path,
              bytes: kIsWeb ? compressFile.bytes : null,
            );
          }
        } else if (sizeInMb > _maxFileSize) {
          PopUpItems().toastMessage(
              "Can't upload file more than 5 mb.", ColorConst.red,
              durationSeconds: 4);
        } else {
          CustomFile customFile = CustomFile(
            name: platformFile.name,
            path: kIsWeb ? null : platformFile.path,
            bytes: kIsWeb ? platformFile.bytes : null,
          );
          return customFile;
        }
      } else {
        AppLog.t("User canceled the picker");
      }
    } catch (e) {
      AppLog.e(e, error: e);
    }
    return null;
  }

  Future<List<CustomFile>?> pickMultipleFile(
      {List<String>? allowedExtensions}) async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        final permissionStatus = await _fileManagerPermission(
            permission: Permission.storage, name: 'File');
        if (!permissionStatus.isGranted) {
          return null;
        }
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: allowedExtensions ?? ['jpeg', 'jpg', 'pdf'],
          allowMultiple: true);

      if (result != null) {
        List<PlatformFile> platformFiles = result.files;

        return List.generate(platformFiles.length, (index) {
          PlatformFile platformFile = platformFiles.elementAt(index);
          return CustomFile(
            name: platformFile.name,
            path: kIsWeb ? null : platformFile.path,
            bytes: kIsWeb ? platformFile.bytes : null,
          );
        });
      } else {
        AppLog.t("User canceled the picker");
      }
    } catch (e) {
      AppLog.e(e, error: e);
    }
    return null;
  }

  Future<CustomFile?> cameraPicker() async {
    try {
      final permissionStatus = await _fileManagerPermission(
          permission: Permission.camera, name: 'Camera');
      if (!permissionStatus.isGranted) {
        return null;
      }

      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        CustomFile? compressFile = await _compressAndResizeImage(CustomFile(
            bytes: await image.readAsBytes(),
            name: image.name,
            path: image.path));
        if (compressFile != null) {
          return CustomFile(
            name: compressFile.name,
            path: kIsWeb ? null : compressFile.path,
            bytes: kIsWeb ? compressFile.bytes : null,
          );
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<CustomFile?> galleryPicker() async {
    try {
      if (!kIsWeb && Platform.isIOS) {
        final permissionStatus = await _fileManagerPermission(
            permission: Permission.photos, name: 'Gallery');
        if (!permissionStatus.isGranted) {
          return null;
        }
      }

      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        CustomFile? compressFile = await _compressAndResizeImage(CustomFile(
            bytes: await image.readAsBytes(),
            name: image.name,
            path: image.path));
        if (compressFile != null) {
          return CustomFile(
            name: compressFile.name,
            path: kIsWeb ? null : compressFile.path,
            bytes: kIsWeb ? compressFile.bytes : null,
          );
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<CustomFile?> customFilePicker({bool? noDocs, bool? noCamera}) async {
    int tag = 3;
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      List<CameraDescription> cameraDescription = [];
      if (noCamera != true) {
        try {
          cameraDescription = await availableCameras();
        } on CameraException catch (e) {
          AppLog.i(e);
        }
      }
      if (cameraDescription.isEmpty || noCamera == true) {
        tag = 2;
      }
      BuildContext context = CurrentContext().context;

      if (context.mounted) {
        String? result = await showModalBottomSheet<String>(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 150,
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (tag == 3)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, 'Camera');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.photo_camera_solid,
                              color: Colors.blueGrey,
                              size: 40,
                            ),
                            8.ph,
                            SizedBox(
                              height: 36,
                              child: CustomText(
                                "Capture Photo.",
                                color: ColorConst.primaryDark,
                                size: 14,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, 'Gallery');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.photo,
                            color: Colors.blueGrey,
                            size: 40,
                          ),
                          8.ph,
                          SizedBox(
                            height: 36,
                            child: CustomText(
                              "Choose from Gallery.",
                              color: ColorConst.primaryDark,
                              size: 14,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, 'Folder');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.folder_solid,
                            color: Colors.blueGrey,
                            size: 40,
                          ),
                          8.ph,
                          SizedBox(
                            height: 36,
                            child: CustomText(
                              "Choose file from device.",
                              color: ColorConst.primaryDark,
                              size: 14,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        if (result == "Camera") {
          return cameraPicker();
        } else if (result == "Gallery") {
          return galleryPicker();
        } else if (result == "Folder") {
          return await pickSingleFile(
              allowedExtensions: noDocs == true ? ['jpeg', 'jpg'] : null);
        }
      }
    } catch (e) {
      AppLog.e(e, error: e);
    }
    return null;
  }

  Future<CustomFile?> _compressAndResizeImage(CustomFile file) async {
    showLoading();
    CustomFile? customFile;
    try {
      await JsProvider().loadJs(
          jsPath: "https://cdn.jsdelivr.net/npm/pica@9.0.1/dist/pica.min.js");
      file.bytes ??= await File(file.path!).readAsBytes();
      ui.Image image = await decodeImageFromList(file.bytes!);

      // Resize the image to have the longer side be 800 pixels
      int width;
      int height;

      if (image.width > image.height) {
        width = 800;
        height = (image.height / image.width * 800).round();
      } else {
        height = 800;
        width = (image.width / image.height * 800).round();
      }

      Uint8List compressedJpegBytes =
          await FlutterImageCompress.compressWithList(file.bytes!,
              minWidth: width,
              minHeight: height,
              quality: 95,
              format: CompressFormat.jpeg);
      String? extension = file.name?.split(".").last;
      String? name = file.name?.split(".$extension").first;
      name = "${name ?? ""}_compressed.jpg";
      if (kIsWeb) {
        customFile = CustomFile(bytes: compressedJpegBytes, name: name);
      } else {
        final Directory tempDir = await getApplicationCacheDirectory();
        // Ensure the directory exists, if not create it
        if (!await tempDir.exists()) {
          await tempDir.create(recursive: true);
        }
        String path = tempDir.path + name;
        File compressedFile = File(path);
        compressedFile.writeAsBytesSync(compressedJpegBytes);
        customFile = CustomFile(path: compressedFile.path, name: name);
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    BuildContext context = CurrentContext().context;
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }

    return customFile;
  }

  Future<PermissionStatus> _fileManagerPermission(
      {required Permission permission, required String name}) async {
    final permissionStatus = await permission.request();
    if (!permissionStatus.isGranted) {
      final currentStatus = await permission.status;
      bool permanentlyDenied = currentStatus.isPermanentlyDenied;
      if (permanentlyDenied) {
        await PopUpItems().cupertinoPopup(
          title: "$name permission Required",
          content:
              "$name access is permanently denied. Please enable it in settings to use this feature.",
          cancelBtnPresses: () {},
          okBtnPressed: () async {
            await openAppSettings();
          },
        );
      } else {
        PopUpItems().toastMessage(
          "$name access is required to use this feature. Please grant permission to continue.",
          ColorConst.baseHexColor,
          durationSeconds: 3,
        );
      }
      final updatedStatus = await permission.status; // Adjust for iOS if needed
      return updatedStatus;
    } else {
      return permissionStatus;
    }
  }
}
