import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dbnus/shared/constants/color_const.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.borderRadius = 16.0,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
  });

  final Widget child;
  final double blur;
  final double borderRadius;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? ColorConst.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: ColorConst.glassBorder,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
