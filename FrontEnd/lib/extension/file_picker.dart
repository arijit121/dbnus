import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../const/color_const.dart';
import '../extension/hex_color.dart';
import '../extension/logger_extension.dart';
import '../extension/spacing.dart';
import '../utils/screen_utils.dart';
import '../widget/custom_text.dart';
import 'package:image_picker/image_picker.dart';

import '../data/model/custom_file.dart';
import '../service/context_service.dart';

Future<CustomFile?> pickSingleFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'jpg', 'pdf'],
    );

    if (result != null) {
      PlatformFile platformFile = result.files.single;

      CustomFile customFile = CustomFile(
        name: platformFile.name,
        path: kIsWeb ? null : platformFile.path,
        bytes: kIsWeb ? platformFile.bytes : null,
      );
      return customFile;
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
          final ImagePicker picker = ImagePicker();
          XFile? image = await picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            return CustomFile(
              name: image.name,
              path: kIsWeb ? null : image.path,
              bytes: kIsWeb ? (await image.readAsBytes()) : null,
            );
          }
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
