import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import '../const/assects_const.dart';
import '../const/color_const.dart';
import '../extension/hex_color.dart';

// ignore: must_be_immutable
class CustomNetWorkImageView extends StatelessWidget {
  CustomNetWorkImageView(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.fit,
      this.radius});

  String url;
  double? height;
  double? width;
  BoxFit? fit;
  double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0.0),
      child: Image.network(
        url,
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
                      color: HexColor.fromHex(ColorConst.baseHexColor)
                          .withOpacity(0.3),
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

// ignore: must_be_immutable
class CustomAssetImageView extends StatelessWidget {
  CustomAssetImageView(
      {super.key,
      required this.path,
      this.height,
      this.width,
      this.fit,
      this.radius,
      this.color});

  String path;
  double? height;
  double? width;
  BoxFit? fit;
  double? radius;
  Color? color;

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
                      color: HexColor.fromHex(ColorConst.baseHexColor)
                          .withOpacity(0.3),
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

// ignore: must_be_immutable
class CustomSvgAssetImageView extends StatelessWidget {
  CustomSvgAssetImageView(
      {super.key,
        required this.path,
        this.height,
        this.width,
        this.fit,
        this.radius,
        this.color});

  String path;
  double? height;
  double? width;
  BoxFit? fit;
  double? radius;
  Color? color;

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
          placeholderBuilder: (
              BuildContext context,
              ) {
            return Container(
              color: HexColor.fromHex(ColorConst.baseHexColor).withOpacity(0.3),
              height: height,
              width: width,
            );
          },
        ),
      ),
    );
  }
}

