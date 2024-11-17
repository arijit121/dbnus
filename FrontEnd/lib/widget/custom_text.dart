import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/open_service.dart';

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
          decorationColor: color),
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
  final TextOverflow overflow;
  final int? maxLines;

  const CustomRichText({
    super.key,
    required this.textSpanList,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.clip,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: textSpanList,
      ),
      overflow: overflow, // Handle text overflow
      maxLines: maxLines,
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
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextDecoration? decoration;
  final bool lineGapNeeded;

  final Color? backGroundColor;

  const CustomHtmlText(
    this.html, {
    super.key,
    this.color,
    this.size,
    this.fontWeight,
    this.maxLines,
    this.decoration,
    this.lineGapNeeded = false,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      textStyle: customizeTextStyle(
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
          decorationColor: color),
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

/// Enum to define various text styles used in the application.
enum CustomTextStyleType {
  heading1(36, FontWeight.w400), // Regular
  heading2(25, FontWeight.w400), // Regular
  heading3(20, FontWeight.w400), // Regular
  subHeading1(18, FontWeight.w500), // Medium
  subHeading2(16, FontWeight.w500), // Medium
  subHeading3(16, FontWeight.w600), // Semi-bold
  body1(16, FontWeight.w400), // Regular
  body2(14, FontWeight.w400), // Regular
  body3(14, FontWeight.w500); // Medium

  /// Font size for the text style.
  final double fontSize;

  /// Font weight for the text style.
  final FontWeight fontWeight;

  /// Constructor to assign properties to the enum values.
  const CustomTextStyleType(this.fontSize, this.fontWeight);
}

/// A customizable text widget that uses an enum for predefined text styles.
///
/// This widget allows the use of predefined styles while also supporting
/// additional customizations like font weight, font size, color, text alignment,
/// and line spacing.
class CustomTextEnumWidget extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The predefined style type for the text.
  final CustomTextStyleType styleType;

  /// The maximum number of lines the text can occupy.
  final int? maxLines;

  /// The alignment of the text.
  final TextAlign? textAlign;

  /// Custom text color to override the default style.
  final Color? color;

  /// Whether additional line spacing is needed.
  final bool lineGapNeeded;

  /// Text decoration for underlining, striking, etc.
  final TextDecoration? decoration;

  /// Custom background color for the text.
  final Color? backGroundColor;

  /// Creates a `CustomTextEnumWidget` with flexible styling options.
  const CustomTextEnumWidget({
    required this.text,
    required this.styleType,
    this.maxLines,
    this.textAlign,
    this.color,
    this.lineGapNeeded = false,
    this.decoration,
    this.backGroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      color: color,
      size: styleType.fontSize,
      fontWeight: styleType.fontWeight,
      maxLines: maxLines,
      decoration: decoration,
      lineGapNeeded: lineGapNeeded,
      textAlign: textAlign,
      backGroundColor: backGroundColor,
    );
  }
}
