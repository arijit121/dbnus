import 'package:dbnus/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../const/color_const.dart';
import '../extension/logger_extension.dart';
import '../service/JsService/provider/js_provider.dart' deferred as js_provider;
import 'custom_button.dart';
import 'custom_text.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfUrl;
  final String? title;

  const PdfViewerWidget({super.key, required this.pdfUrl, this.title});

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
          js_provider.JsProvider().loadJs(
              jsPath:
                  "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.11.338/pdf.min.js"),
          js_provider.JsProvider().loadJs(
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
      body: ValueListenableBuilder<bool>(
          valueListenable: loaded,
          builder: (BuildContext context, bool value, child) {
            return value
                ? SfPdfViewer.network(widget.pdfUrl,
                    maxZoomLevel: 10,
                    scrollDirection: PdfScrollDirection.horizontal)
                : Center(
                    child: LoadingWidget(),
                  );
          }),
    );
  }
}
