import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

import 'package:dbnus/shared/constants/assects_const.dart';

class NetworkImg extends StatelessWidget {
  const NetworkImg(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.borderRadius = BorderRadius.zero,
      this.fit,
      this.color,
      this.errorWidget,
      this.loadingWidget});

  final String url;
  final double? height, width;
  final BoxFit? fit;
  final Color? color;
  final Widget? loadingWidget, errorWidget;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width != 0.0 ? width : null,
        height: height != 0.0 ? height : null,
        fit: fit,
        color: color,
        memCacheWidth: (width != null && width != 0 && width != double.infinity
                ? width
                : 320)
            ?.toInt(),
        memCacheHeight:
            (height != null && height != 0 && height != double.infinity
                    ? height
                    : 320)
                ?.toInt(),
        maxWidthDiskCache:
            (width != null && width != 0 && width != double.infinity
                    ? width
                    : 320)
                ?.toInt(),
        maxHeightDiskCache:
            (height != null && height != 0 && height != double.infinity
                    ? height
                    : 320)
                ?.toInt(),
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
                    borderRadius: borderRadius,
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
