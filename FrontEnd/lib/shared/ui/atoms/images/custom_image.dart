import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:dbnus/core/constants/assects_const.dart';
import 'package:dbnus/core/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/images/network_img/network_img.dart';

class CustomNetWorkImageView extends StatelessWidget {
  const CustomNetWorkImageView({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.contain, // Default BoxFit value
    this.radius,
    this.color,
    this.loadingWidget,
    this.errorWidget,
  });

  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double? radius;
  final Color? color;
  final Widget? loadingWidget, errorWidget;

  @override
  Widget build(BuildContext context) {
    return NetworkImg(
      url: url,
      width: width,
      height: height,
      radius: radius,
      fit: fit,
      color: color,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
    );
  }
}

class CustomAssetImageView extends StatelessWidget {
  const CustomAssetImageView(
      {super.key,
      required this.path,
      this.height,
      this.width,
      this.fit,
      this.radius,
      this.color});

  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0.0),
      child: Image.asset(
        path,
        color: color,
        width: width != 0.0 ? width : null,
        height: height != 0.0 ? height : null,
        fit: fit ?? BoxFit.contain,
        frameBuilder: (BuildContext context, Widget child, int? frame,
            bool? wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded == true) {
            return child;
          } else {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: frame != null
                  ? child
                  : Container(
                      color: ColorConst.baseHexColor.withOpacity(0.3),
                      height: height,
                      width: width,
                    ),
            );
          }
        },
        errorBuilder: (_, __, ___) {
          return Image.asset(
            AssetsConst.dbnusNoImageLogo,
            width: width != 0.0 ? width : null,
            height: height != 0.0 ? height : null,
          );
        },
      ),
    );
  }
}

class CustomSvgAssetImageView extends StatelessWidget {
  const CustomSvgAssetImageView(
      {super.key,
      required this.path,
      this.height,
      this.width,
      this.fit,
      this.radius,
      this.color});

  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != 0.0 ? width : null,
      height: height != 0.0 ? height : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0.0),
        child: SvgPicture.asset(
          path,
          width: width != 0.0 ? width : null,
          height: height != 0.0 ? height : null,
          fit: fit ?? BoxFit.contain,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          placeholderBuilder: (BuildContext context) {
            return Container(
              color: ColorConst.baseHexColor.withOpacity(0.3),
              height: height,
              width: width,
            );
          },
        ),
      ),
    );
  }
}

class CustomSvgNetworkImageView extends StatelessWidget {
  const CustomSvgNetworkImageView(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.fit,
      this.radius,
      this.color});

  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != 0.0 ? width : null,
      height: height != 0.0 ? height : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0.0),
        child: SvgPicture.network(
          url,
          width: width != 0.0 ? width : null,
          height: height != 0.0 ? height : null,
          fit: fit ?? BoxFit.contain,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          placeholderBuilder: (BuildContext context) {
            return Container(
              color: ColorConst.baseHexColor.withOpacity(0.3),
              height: height,
              width: width,
            );
          },
        ),
      ),
    );
  }
}
