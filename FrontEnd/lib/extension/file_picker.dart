import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../const/color_const.dart';
import '../extension/hex_color.dart';
import '../extension/logger_extension.dart';
import '../extension/spacing.dart';
import '../utils/pop_up_items.dart';
import '../utils/screen_utils.dart';
import '../widget/custom_text.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/custom_file.dart';
import '../service/context_service.dart';

class CustomFilePicker {
  final int _maxFileSize = 5;

  Future<CustomFile?> pickSingleFile() async {
    try {
      List<String> allowedExtensions = ['jpeg', 'jpg', 'pdf'];
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        PlatformFile platformFile = result.files.single;
        int sizeInBytes = platformFile.size;
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (!allowedExtensions.contains(platformFile.extension)) {
          PopUpItems().toastMessage("Invalid file type.", Colors.red,
              durationSeconds: 4);
        } else if (sizeInMb > _maxFileSize) {
          PopUpItems().toastMessage(
              "Can't upload file more than 5 mb.", Colors.red,
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

  Future<List<CustomFile>?> pickMultipleFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpeg', 'jpg', 'pdf'],
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
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        int sizeInBytes = await image.length();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > _maxFileSize) {
          PopUpItems().toastMessage(
              "Can't upload file more than 5 mb.", Colors.red,
              durationSeconds: 4);
        } else {
          return CustomFile(
            name: image.name,
            path: kIsWeb ? null : image.path,
            bytes: kIsWeb ? (await image.readAsBytes()) : null,
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
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        int sizeInBytes = await image.length();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > _maxFileSize) {
          PopUpItems().toastMessage(
              "Can't upload file more than 5 mb.", Colors.red,
              durationSeconds: 4);
        } else {
          return CustomFile(
            name: image.name,
            path: kIsWeb ? null : image.path,
            bytes: kIsWeb ? (await image.readAsBytes()) : null,
          );
        }
      }
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<CustomFile?> customFilePicker() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      List<CameraDescription> cameraDescription = [];
      try {
        cameraDescription = await availableCameras();
      } on CameraException catch (e) {
        AppLog.i(e);
      }
      if (cameraDescription.isEmpty) {
        return await pickSingleFile();
      } else {
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
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, 'Camera');
                      },
                      child: SizedBox(
                        width: (ScreenUtils.nw() / 2) - 8,
                        child: Column(
                          children: [
                            IconButton(
                                color: Colors.blueGrey,
                                iconSize: 40,
                                onPressed: () {
                                  Navigator.pop(context, 'Camera');
                                },
                                icon: const Icon(
                                    CupertinoIcons.photo_camera_solid)),
                            8.ph,
                            CustomText(
                              "Capture Photo.",
                              color: HexColor.fromHex(ColorConst.primaryDark),
                              size: 14,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, 'Folder');
                      },
                      child: SizedBox(
                        width: (ScreenUtils.nw() / 2) - 8,
                        child: Column(
                          children: [
                            IconButton(
                                color: Colors.blueGrey,
                                iconSize: 40,
                                onPressed: () {
                                  Navigator.pop(context, 'Folder');
                                },
                                icon: const Icon(CupertinoIcons.folder_solid)),
                            8.ph,
                            CustomText(
                              "Choose file from device.",
                              color: HexColor.fromHex(ColorConst.primaryDark),
                              size: 14,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
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
          } else if (result == "Folder") {
            return await pickSingleFile();
          }
        }
      }
    } catch (e) {
      AppLog.e(e, error: e);
    }
    return null;
  }
}
