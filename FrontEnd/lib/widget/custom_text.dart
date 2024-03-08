import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:genu/service/open_url_service.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle customizeTextStyle(
    {FontWeight? fontWeight,
    double? fontSize,
    Color? fontColor,
    TextDecoration? decoration,
    Color? decorationColor,
    double? height,
    Color? backgroundColor}) {
  return GoogleFonts.inter(
      decoration: decoration,
      fontWeight: fontWeight,
      wordSpacing: 0,
      color: fontColor,
      fontSize: fontSize,
      decorationColor: decorationColor,
      height: height,
      backgroundColor: backgroundColor);
}

Widget customText(
  String text,
  Color color,
  double size, {
  FontWeight? fontWeight,
  int? maxLines,
  bool? lineThrough,
  bool lineGapNeeded = false,
  TextAlign? textAlign,
  Color? backGroundColor,
}) {
  return Text(
    text,
    maxLines: maxLines,
    textAlign: textAlign,
    style: customizeTextStyle(
      fontWeight: fontWeight,
      fontSize: size,
      fontColor: color,
      height: lineGapNeeded == true
          ? 1.8
          : kIsWeb
              ? 1.2
              : 0.0,
      decoration: lineThrough == true
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      backgroundColor: backGroundColor,
    ),
  );
}

Widget customInkWellText(
  Function() onTap,
  String text,
  Color color,
  double size, {
  fontWeight,
  Key? key,
}) {
  return InkWell(
    key: key,
    onTap: onTap,
    child: Text(text,
        style: customizeTextStyle(
          fontWeight: fontWeight,
          fontSize: size,
          fontColor: color,
        )),
  );
}

Widget customRichText(
    {required List<TextSpan> textSpanList,
    TextAlign textAlign = TextAlign.start}) {
  return RichText(
    textAlign: textAlign,
    text: TextSpan(
      children: textSpanList,
    ),
  );
}

TextSpan customTextSpan({
  required String text,
  FontWeight? fontWeight,
  required double fontSize,
  required Color fontColor,
  TextDecoration? decoration,
  Color? decorationColor,
  double? height,
  Color? backgroundColor,
}) =>
    TextSpan(
        text: text,
        style: customizeTextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontColor: fontColor,
            decoration: decoration,
            decorationColor: decorationColor,
            height: height,
            backgroundColor: backgroundColor));

Widget customUnderlineText(String text, Color color, double size,
    {fontWeight, decorationColor, TextAlign? textAlign}) {
  return Text(text,
      textAlign: textAlign,
      style: customizeTextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontColor: color,
        decoration: TextDecoration.underline,
        decorationColor: decorationColor,
      ));
}

Widget customOverflowText(String text, Color color, double size,
    {fontWeight,
    int maxLines = 2,
    TextAlign? textAlign = TextAlign.center,
    TextOverflow? overflow}) {
  return Text(text,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      maxLines: maxLines,
      style: customizeTextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontColor: color,
      ));
}

Widget customOnlyText(
  String data, {
  Key? key,
  TextStyle? style,
  StrutStyle? strutStyle,
  TextAlign? textAlign,
  Locale? locale,
  bool? softWrap,
  TextOverflow? overflow,
  double? textScaleFactor,
  int? maxLines,
  String? semanticsLabel,
  TextWidthBasis? textWidthBasis,
  TextHeightBehavior? textHeightBehavior,
  Color? selectionColor,
}) {
  return Text(
    data,
    key: key,
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: TextScaler.linear(textScaleFactor ?? 0.0),
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );
}

Widget customHtmlText(String html) => HtmlWidget(
      html,
      textStyle: customizeTextStyle(),
      onTapUrl: (url) async {
        await OpenUrlService().openUrl(uri: Uri.parse(url));
        return true;
      },
    );
