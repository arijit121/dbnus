import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

      await _printPdfBytes(pdfBytes: response, fileName: fileName);
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

      await _printPdfBytes(pdfBytes: pdfBytes, fileName: fileName);
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
  }

  static Future<void> _printPdfBytes({
    required Uint8List pdfBytes,
    String? fileName,
  }) async {
    final info = await Printing.info();

    // Direct print and listing printers are only supported on platforms with those capabilities
    if (info.canListPrinters && info.directPrint) {
      final printer = await pickCustomPrinter(CurrentContext().context);

      if (printer == null) {
        return;
      }

      await Printing.directPrintPdf(
        printer: printer,
        name: fileName ?? "Document",
        onLayout: (_) async => pdfBytes,
      );
      return;
    }

    // Universal fallback for platforms without directPrint / canListPrinters support (e.g. Android, Web)
    await Printing.layoutPdf(
      name: fileName ?? "Document",
      onLayout: (_) async => pdfBytes,
    );
  }

  static Future<Printer?> pickCustomPrinter(BuildContext context) async {
    final printers = await Printing.listPrinters();

    if (printers.isEmpty) {
      PopUpItems.toastMessage('No printers found.', ColorConst.red);
      return null;
    }

    printers.sort((a, b) {
      if (a.isDefault) return -1;
      if (b.isDefault) return 1;
      return a.name.compareTo(b.name);
    });

    if (!context.mounted) return null;

    return showDialog<Printer>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Printer'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: printers.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final printer = printers[index];
                return ListTile(
                  leading:
                      const Icon(Icons.print, color: ColorConst.primaryDark),
                  title: Text(
                    printer.name,
                    style: TextStyle(
                      fontWeight: printer.isDefault
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: printer.location != null &&
                          printer.location!.isNotEmpty
                      ? Text(printer.location!)
                      : (printer.model != null && printer.model!.isNotEmpty
                          ? Text(printer.model!)
                          : null),
                  trailing: printer.isDefault
                      ? const Chip(
                          label: Text(
                            'Default',
                            style: TextStyle(fontSize: 10),
                          ),
                        )
                      : null,
                  enabled: printer.isAvailable,
                  onTap: () => Navigator.of(context).pop(printer),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

