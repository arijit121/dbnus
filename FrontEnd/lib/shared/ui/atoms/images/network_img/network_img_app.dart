import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:dbnus/core/constants/assects_const.dart';

class NetworkImg extends StatelessWidget {
  const NetworkImg(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.radius,
      this.fit,
      this.color,
      this.errorWidget,
      this.loadingWidget});

  final String url;
  final double? height, width, radius;
  final BoxFit? fit;
  final Color? color;
  final Widget? loadingWidget, errorWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width != 0.0 ? width : null,
        height: height != 0.0 ? height : null,
        fit: fit,
        color: color,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return loadingWidget ??
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white, // Shimmer background color
                    borderRadius: BorderRadius.circular(radius ?? 0),
                  ),
                ),
              );
        },
        errorWidget: (_, __, ___) {
          return errorWidget ??
              Image.asset(
                AssetsConst.dbnusNoImageLogo,
                // Use your local error image asset
                width: width,
                height: height,
                fit: fit,
              );
        },
        imageBuilder: (context, imageProvider) {
          return Image(
            image: imageProvider,
            width: width,
            height: height,
            fit: fit,
            color: color,
          );
        },
      ),
    );
  }
}
