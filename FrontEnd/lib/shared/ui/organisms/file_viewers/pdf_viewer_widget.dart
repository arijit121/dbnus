import 'dart:typed_data';

import 'package:dbnus/shared/ui/atoms/indicators/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/network/api_client/repo/api_repo.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/JsService/provider/js_provider.dart'
    deferred as js_provider;
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/molecules/error/error_widget.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;
  final String? title;
  final Map<String, String>? headers;

  const PdfViewerWidget(
      {super.key, required this.pdfUrl, this.title, this.headers});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final ValueNotifier<bool> loaded = ValueNotifier<bool>(false);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await js_provider.loadLibrary();
        await Future.wait([
          js_provider.JsProvider.loadJs(
              jsPath:
                  "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.min.js"),
          js_provider.JsProvider.loadJs(
              jsPath:
                  "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.worker.min.js")
        ]);
        loaded.value = true;
      } catch (e, stacktrace) {
        AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CustomIconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_sharp),
          color: ColorConst.primaryDark,
        ),
        title: CustomTextEnum(
          widget.title ?? (widget.pdfUrl.split("/").last).split(".").first,
          color: ColorConst.primaryDark,
          styleType: CustomTextStyleType.subHeading3,
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
            valueListenable: loaded,
            builder: (BuildContext context, bool value, child) {
              return value
                  ? FutureBuilder<Uint8List?>(
                      future: ApiEngine.instance.urlToByte(
                          uri: widget.pdfUrl,
                          headers: widget.headers,
                          tag: 'Pdf'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: LoadingWidget());
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return SfPdfViewer.memory(snapshot.data!,
                              key: GlobalKey(),
                              maxZoomLevel: 10,
                              scrollDirection: PdfScrollDirection.vertical);
                        } else {
                          return Center(child: CustomErrorWidget());
                        }
                      },
                    )
                  : Center(child: LoadingWidget());
            }),
      ),
    );
  }
}
