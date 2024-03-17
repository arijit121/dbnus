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
        errorBuilder: (_, __, ___) {
          return Image.asset(
            AssetsConst.genuNoImageLogo,
            width: width != 0.0 ? width : null,
            height: height != 0.0 ? height : null,
          );
        },
      ),
    );
