import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/open_service.dart';
import '../service/value_handler.dart';

TextStyle customizeTextStyle(
    {FontWeight? fontWeight,
    double? fontSize,
    Color? fontColor,
    TextDecoration? decoration,
    Color? decorationColor,
    double? height,
    Color? backgroundColor,
    String? font}) {
  return ValueHandler().isTextNotEmptyOrNull(font)
      ? GoogleFonts.getFont(font!,
          decoration: decoration,
          fontWeight: fontWeight,
          wordSpacing: 0,
          color: fontColor,
          fontSize: fontSize,
          decorationColor: decorationColor,
          height: height,
          backgroundColor: backgroundColor)
      : GoogleFonts.inter(
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
  final String? font;
  final TextOverflow? overflow;

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
    this.font,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: customizeTextStyle(
          font: font,
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

class CustomRichText extends StatelessWidget {
  final List<InlineSpan> textSpanList;
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

WidgetSpan CustomTextSpan(
        {required String text,
        FontWeight? fontWeight,
        double? size,
        Color? color,
        TextDecoration? decoration,
        Color? decorationColor,
        double? height,
        Color? backgroundColor,
        String? font,
        PlaceholderAlignment alignment = PlaceholderAlignment.baseline}) =>
    WidgetSpan(
      alignment: alignment,
      baseline: TextBaseline.alphabetic,
      child: Text(
        text,
        style: customizeTextStyle(
            font: font,
            fontWeight: fontWeight,
            fontSize: size,
            fontColor: color,
            decoration: decoration,
            decorationColor: decorationColor,
            height: height,
            backgroundColor: backgroundColor),
      ),
    );

WidgetSpan CustomTextSpanEnum(
        {required String text,
        required CustomTextStyleType styleType,
        Color? color,
        TextDecoration? decoration,
        Color? decorationColor,
        double? height,
        Color? backgroundColor,
        String? font}) =>
    CustomTextSpan(
        text: text,
        fontWeight: styleType.fontWeight,
        size: styleType.fontSize,
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        height: height,
        backgroundColor: backgroundColor,
        font: font);

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
  final String? font;

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
    this.font,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      textStyle: customizeTextStyle(
          font: font,
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
  final String? font;
  final int maxLines;

  const CustomExpandableText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.font,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      textAlign: textAlign,
      style: customizeTextStyle(
        font: font,
        fontWeight: fontWeight,
        fontSize: size,
        fontColor: color,
      ),
      expandText: 'show more',
      collapseText: 'show less',
      maxLines: maxLines,
      linkColor: Colors.blue,
    );
  }
}

/// An enum representing various custom text styles.
/// Each style is defined with a specific font size and font weight.
enum CustomTextStyleType {
  /// Heading 1 style with a font size of 36 and a regular font weight.
  heading1(36, FontWeight.w400),

  /// Heading 2 style with a font size of 25 and a regular font weight.
  heading2(25, FontWeight.w400),

  /// Heading 3 style with a font size of 20 and a regular font weight.
  heading3(20, FontWeight.w400),

  /// Sub-heading 1 style with a font size of 18 and a medium font weight.
  subHeading1(18, FontWeight.w500),

  /// Sub-heading 2 style with a font size of 16 and a medium font weight.
  subHeading2(16, FontWeight.w500),

  /// Sub-heading 3 style with a font size of 16 and a semi-bold font weight.
  subHeading3(16, FontWeight.w600),

  /// Body 1 style with a font size of 16 and a regular font weight.
  body1(16, FontWeight.w400),

  /// Body 2 style with a font size of 14 and a regular font weight.
  body2(14, FontWeight.w400),

  /// Body 3 style with a font size of 14 and a medium font weight.
  body3(14, FontWeight.w500);

  /// The font size for the text style.
  final double fontSize;

  /// The font weight for the text style.
  final FontWeight fontWeight;

  /// A constructor to assign font size and weight to each text style.
  const CustomTextStyleType(this.fontSize, this.fontWeight);
}

/// A customizable text widget that uses an enum for predefined text styles.
///
/// This widget allows the use of predefined styles while also supporting
/// additional customizations like font weight, font size, color, text alignment,
/// and line spacing.
class CustomTextEnum extends StatelessWidget {
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

  /// Custom text font.
  final String? font;

  /// Creates a `CustomTextEnumWidget` with flexible styling options.
  const CustomTextEnum(
    this.text, {
    required this.styleType,
    this.maxLines,
    this.textAlign,
    this.color,
    this.lineGapNeeded = false,
    this.decoration,
    this.backGroundColor,
    this.font,
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
      font: font,
    );
  }
}
