import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../service/open_service.dart';
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

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextDecoration? decoration;
  final bool lineGapNeeded;
  final TextAlign? textAlign;
  final Color? backGroundColor;

  const CustomText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.fontWeight,
    this.maxLines,
    this.decoration,
    this.lineGapNeeded = false,
    this.textAlign,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
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
        decoration: decoration,
        backgroundColor: backGroundColor,
      ),
    );
  }
}

class CustomInkWellText extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;

  const CustomInkWellText(
    this.text, {
    super.key,
    this.onTap,
    this.color,
    this.size,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
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
}

class CustomRichText extends StatelessWidget {
  final List<TextSpan> textSpanList;
  final TextAlign textAlign;

  const CustomRichText({
    super.key,
    required this.textSpanList,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: textSpanList,
      ),
    );
  }
}

TextSpan customTextSpan({
  required String text,
  FontWeight? fontWeight,
  double? size,
  Color? color,
  TextDecoration? decoration,
  Color? decorationColor,
  double? height,
  Color? backgroundColor,
}) =>
    TextSpan(
        text: text,
        style: customizeTextStyle(
            fontWeight: fontWeight,
            fontSize: size,
            fontColor: color,
            decoration: decoration,
            decorationColor: decorationColor,
            height: height,
            backgroundColor: backgroundColor));

class CustomUnderlineText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final Color? decorationColor;
  final TextAlign? textAlign;

  const CustomUnderlineText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.fontWeight,
    this.decorationColor,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
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
}

class CustomOverflowText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final int maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const CustomOverflowText(
    this.text, {
    super.key,
    this.size,
    this.color,
    this.fontWeight,
    this.maxLines = 2,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
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
}

class CustomOnlyText extends StatelessWidget {
  final String data;

  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const CustomOnlyText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
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
}

class CustomHtmlText extends StatelessWidget {
  final String html;

  const CustomHtmlText(this.html, {super.key});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      textStyle: customizeTextStyle(),
      onTapUrl: (url) async {
        await OpenService().openUrl(uri: Uri.parse(url));
        return true;
      },
    );
  }
}

class CustomExpandableText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const CustomExpandableText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      textAlign: textAlign,
      style: customizeTextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontColor: color,
      ),
      expandText: 'show more',
      collapseText: 'show less',
      maxLines: 1,
      linkColor: Colors.blue,
    );
  }
}
