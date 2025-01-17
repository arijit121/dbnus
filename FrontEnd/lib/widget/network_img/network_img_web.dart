import 'dart:convert';
import 'dart:ui_web' as web_ui;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../../const/assects_const.dart';
import '../../const/color_const.dart';
import '../../extension/logger_extension.dart';

class NetworkImg extends StatefulWidget {
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
  State<NetworkImg> createState() => _NetworkImgState();
}

class _NetworkImgState extends State<NetworkImg> {
  ValueNotifier<bool> errorFound = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final String localStorageKey =
        'cached_image_${widget.url}'; // Unique key for caching

    // Check if image is already cached
    final cachedImage = web.window.localStorage[localStorageKey];
    if (cachedImage != null) {
      return _buildImageFromCache(cachedImage);
    }

    // Register HTML image element for web
    web_ui.platformViewRegistry.registerViewFactory(
      widget.url,
      (int viewId) {
        final imageElement = web.HTMLImageElement()
          ..src = widget.url
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = _getObjectFit(widget.fit)
          // ..crossOrigin = 'anonymous' // Set CORS attribute
          ..draggable = false; // Disable dragging

        // Apply CSS color filter if color is provided
        if (widget.color != null) {
          final hsvColor = HSVColor.fromColor(widget.color!);
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

        // Handle image loading errors
        imageElement.onError.listen((_) {
          errorFound.value = true;
          web.window.localStorage.removeItem(localStorageKey);
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

    return ValueListenableBuilder<bool>(
      valueListenable: errorFound,
      builder: (BuildContext context, bool shouldScroll, _) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            if (errorFound.value)
              widget.errorWidget ??
                  Image.asset(
                    AssetsConst.dbnusNoImageLogo,
                    width: widget.width,
                    height: widget.height,
                  )
            else
              SizedBox(
                width: widget.width ?? 120,
                height: widget.height ?? 120,
                child: HtmlElementView(viewType: widget.url),
              ),
            Material(
              color: Colors.transparent,
              child: SizedBox(
                width: widget.width ?? 120,
                height: widget.height ?? 120,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageFromCache(String base64Image) {
    return Image.memory(
      base64Decode(base64Image),
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
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
                    height: widget.height,
                    width: widget.width,
                  ),
          );
        }
      },
      errorBuilder: (_, __, ___) {
        return widget.errorWidget ??
            Image.asset(
              AssetsConst.dbnusNoImageLogo,
              width: widget.width,
              height: widget.height,
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
