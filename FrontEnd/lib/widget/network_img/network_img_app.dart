import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../const/assects_const.dart';

class NetworkImg extends StatelessWidget {
  const NetworkImg(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.fit,
      this.color,
      this.errorWidget});

  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width != 0.0 ? width : null,
      height: height != 0.0 ? height : null,
      fit: fit,
      color: color,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: width,
            height: height,
            color: Colors.white, // Shimmer background color
          ),
        );
      },
      errorWidget: (_, __, ___) {
        return errorWidget ??
            Image.asset(
              AssetsConst.dbnusNoImageLogo, // Use your local error image asset
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
    );
  }
}
