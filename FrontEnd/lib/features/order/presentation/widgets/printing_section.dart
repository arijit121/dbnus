import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/services/printing_handler.dart';
import 'package:dbnus/core/services/file_picker.dart';
import 'package:dbnus/core/models/custom_file.dart';

import 'order_tool_tile.dart';

class PrintingSection extends StatelessWidget {
  const PrintingSection({super.key});

  Widget _buildDivider() =>
      const Divider(height: 1, indent: 56, color: ColorConst.lineGrey);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          OrderToolTile(
            icon: FeatherIcons.printer,
            title: "Print PDF from URL",
            subtitle: "Download and print a sample PDF",
            color: ColorConst.primaryDark,
            onTap: () {
              PrintingHandler.printPdfFromUrl(
                url:
                    "https://file-examples.com/storage/fea01aba4069c2c9293af8d/2017/10/file-example_PDF_1MB.pdf",
                fileName: "SamplePDF",
              );
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.fileText,
            title: "Print Local PDF",
            subtitle: "Select a PDF from your device to print",
            color: ColorConst.violate,
            onTap: () async {
              CustomFile? pickedFile = await CustomFilePicker.pickSingleFile(
                allowedExtensions: ['pdf'],
              );
              if (pickedFile != null) {
                PrintingHandler.printPdfFromFile(
                  file: pickedFile,
                  fileName: pickedFile.name,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
