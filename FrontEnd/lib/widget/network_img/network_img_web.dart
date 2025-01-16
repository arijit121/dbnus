import 'dart:convert';
import 'dart:ui_web' as web_ui;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../const/assects_const.dart';
import '../../const/color_const.dart';
import '../../extension/logger_extension.dart';

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
    final String localStorageKey =
        'cached_image_$url'; // Unique key for caching

    // Check if image is already cached
    final cachedImage = web.window.localStorage[localStorageKey];
    if (cachedImage != null) {
      return _buildImageFromCache(cachedImage);
    }

    // Register HTML image element for web
    web_ui.platformViewRegistry.registerViewFactory(
      url,
      (int viewId) {
        final imageElement = web.HTMLImageElement()
          ..src = url
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = _getObjectFit(fit)
          // ..crossOrigin = 'anonymous' // Set CORS attribute
          ..draggable = false; // Disable dragging

        // Apply CSS color filter if color is provided
        if (color != null) {
          final hsvColor = HSVColor.fromColor(color!);
          final hue = hsvColor.hue;
          final saturation = hsvColor.saturation * 100;
          final brightness = hsvColor.value * 100;

          imageElement.style.filter =
              'sepia(1) hue-rotate(${hue}deg) saturate($saturation%) brightness($brightness%)';
        }

        imageElement.onLoad.listen((_) {
          try {
            // Convert the image to a base64 string and store it
            final canvas = web.HTMLCanvasElement();
            final context = canvas.context2D;
            canvas.width = imageElement.width;
            canvas.height = imageElement.height;
            context.drawImage(imageElement, 0, 0);
            final base64Image = canvas
                .toDataUrl('image/png')
                .split(',')[1]; // Get base64 string
            web.window.localStorage[localStorageKey] =
                base64Image; // Cache the image
          } catch (e, stacktrace) {
            AppLog.e(e.toString(),
                error: e,
                stackTrace: stacktrace,
                tag: "Failed to export canvas");
          }
        });

        return imageElement;
      },
    );

    // Add event listener to clear cache on session destruction
    web.document.onVisibilityChange.listen((event) {
      if (web.document.visibilityState == 'hidden') {
        web.window.localStorage.removeItem(localStorageKey);
      }
    });

    return Stack(
      children: [
        errorWidget ??
            Image.asset(
              AssetsConst.dbnusNoImageLogo,
              width: width != 0.0 ? width : null,
              height: height != 0.0 ? height : null,
              color: ColorConst.blueGrey,
            ),
        SizedBox(
          width: width,
          height: height,
          child: HtmlElementView(viewType: url),
        ),
        Material(
          color: Colors.transparent,
          child: SizedBox(
            width: width,
            height: height,
          ),
        ),
      ],
    );
  }

  Widget _buildImageFromCache(String base64Image) {
    return Image.memory(
      base64Decode(base64Image),
      width: width,
      height: height,
      fit: fit,
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
        return errorWidget ??
            Image.asset(
              AssetsConst.dbnusNoImageLogo,
              width: width != 0.0 ? width : null,
              height: height != 0.0 ? height : null,
            );
      },
    );
  }

  // Convert Flutter's BoxFit to CSS object-fit for web
  String _getObjectFit(BoxFit? fit) {
    switch (fit) {
      case BoxFit.cover:
        return 'cover';
      case BoxFit.contain:
        return 'contain';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.fitWidth:
        return 'scale-down';
      case BoxFit.fitHeight:
        return 'scale-down';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
      default:
        return '';
    }
  }
}
