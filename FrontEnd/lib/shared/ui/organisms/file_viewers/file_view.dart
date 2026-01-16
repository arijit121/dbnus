import 'dart:io';

import 'package:dbnus/core/constants/assects_const.dart';
import 'package:dbnus/core/models/custom_file.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/utils/custom_ui.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/constants/color_const.dart';

class FileView extends StatelessWidget {
  const FileView({
    super.key,
    required this.file,
    this.height,
    this.width,
    this.onDelete,
  });

  final CustomFile file;
  final double? height;
  final double? width;
  final void Function()? onDelete;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(8),
      borderColor: Colors.grey.shade300,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          file.name?.toLowerCase().contains(".pdf") == true
              ? LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CustomAssetImageView(
                          path: AssetsConst.pdf, height: height, width: width),
                      CustomText(
                        file.name ?? "",
                        color: Colors.white,
                        size: 10,
                        maxLines: 1,
                      )
                    ],
                  );
                })
              : file.path != null
                  ? Image.file(File(file.path!), height: height, width: width)
                  : file.bytes != null
                      ? Image.memory(file.bytes!, height: height, width: width)
                      : CustomAssetImageView(
                          path: AssetsConst.dbnusNoImageLogo,
                          height: height,
                          width: width),
          if (onDelete != null)
            CustomIconButton(
                color: ColorConst.red,
                icon: const Icon(Icons.delete),
                onPressed: onDelete),
        ],
      ),
    );
  }
}
