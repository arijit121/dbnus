import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';

import '../../shared/constants/color_const.dart';
import '../../shared/extensions/logger_extension.dart';
import '../../shared/ui/atoms/indicators/loading_widget.dart';
import '../../shared/utils/pop_up_items.dart';
import '../models/custom_file.dart';
import '../network/api_client/repo/api_repo.dart';
import 'context_service.dart';

class PrintingHandler {
  static Future<void> printPdfFromUrl(
      {required String url, String? fileName}) async {
    try {
      showLoading();

      final response = await ApiEngine.instance
          .urlToByte(uri: url, tag: "Bytes ${fileName ?? ""}");

      hideLoading();

      if (response == null) {
        PopUpItems.toastMessage('Failed to load PDF', ColorConst.red);
        return;
      }

      final pdfBytes = response;

      /// ✅ WEB → fallback
      if (kIsWeb) {
        await Printing.layoutPdf(
          name: fileName ?? "Document",
          onLayout: (_) async => pdfBytes,
        );
        return;
      }

      /// ✅ MOBILE / DESKTOP
      final printer =
          await Printing.pickPrinter(context: CurrentContext().context);

      if (printer == null) {
        PopUpItems.toastMessage('Pick a printer to proceed.', ColorConst.red);
        return;
      }

      await Printing.directPrintPdf(
        printer: printer,
        name: fileName ?? "Document",
        onLayout: (_) async => pdfBytes,
      );
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<void> printPdfFromFile(
      {required CustomFile file, String? fileName}) async {
    try {
      final Uint8List pdfBytes;
      if (kIsWeb) {
        pdfBytes = file.bytes!;
      } else {
        pdfBytes = await File(file.path!).readAsBytes();
      }

      /// ✅ WEB → fallback
      if (kIsWeb) {
        await Printing.layoutPdf(
          name: fileName ?? "Document",
          onLayout: (_) async => pdfBytes,
        );
        return;
      }

      /// ✅ MOBILE / DESKTOP
      final printer =
          await Printing.pickPrinter(context: CurrentContext().context);

      if (printer == null) {
        PopUpItems.toastMessage('Pick a printer to proceed.', ColorConst.red);
        return;
      }

      await Printing.directPrintPdf(
        printer: printer,
        name: fileName ?? "Document",
        onLayout: (_) async => pdfBytes,
      );
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }
}
