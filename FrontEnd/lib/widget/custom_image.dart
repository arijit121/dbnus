import 'package:flutter/material.dart';
import '../const/assects_const.dart';

Widget customNetWorkImageView(
        {required String url,
        double? height,
        double? width,
        BoxFit? fit,
        double? radius}) =>
    ClipRRect(
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
                  : Image.asset(
                      AssetsConst.genuNoImageLogo,
                      width: width != 0.0 ? width : null,
                      height: height != 0.0 ? height : null,
                    ),
            );
          }
        },
        errorBuilder: (_, __, ___) {
          return Image.asset(
            AssetsConst.genuNoImageLogo,
            width: width != 0.0 ? width : null,
            height: height != 0.0 ? height : null,
          );
        },
      ),
    );

class ImageWidgetPlaceholder extends StatelessWidget {
  const ImageWidgetPlaceholder({
    super.key,
    required this.image,
    required this.placeholder,
  });
  final ImageProvider image;
  final Widget placeholder;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      frameBuilder: (BuildContext context, Widget child, int? frame,
          bool? wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded == true) {
          return child;
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: frame != null ? child : placeholder,
          );
        }
      },
    );
  }
}
