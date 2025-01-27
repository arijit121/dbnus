import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web/web.dart' as web;
import 'package:web/web.dart';

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
        return _CorsNetworkImg(
          url: url,
          width: width,
          height: height,
          fit: fit,
          color: color,
          errorWidget: errorWidget,
        );
        // Image.asset(
        //   AssetsConst.dbnusNoImageLogo,
        //   width: width,
        //   height: height,
        // );
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

class _CorsNetworkImg extends StatefulWidget {
  const _CorsNetworkImg(
      {required this.url,
      this.height,
      this.width,
      this.fit,
      this.color,
      this.errorWidget})
      : assert(height != null || width != null,
            'Height or Width must be provided for CorsNetworkImg');

  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final Widget? errorWidget;

  @override
  State<_CorsNetworkImg> createState() => _CorsNetworkImgState();
}

class _CorsNetworkImgState extends State<_CorsNetworkImg> {
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

    // Add event listener to clear cache on session destruction
    web.document.onVisibilityChange.listen((event) {
      if (web.document.visibilityState == 'hidden') {
        web.window.localStorage.removeItem(localStorageKey);
      }
    });

    return ValueListenableBuilder<bool>(
      valueListenable: errorFound,
      builder: (BuildContext context, bool shouldScroll, _) {
        return errorFound.value
            ? widget.errorWidget ??
                Image.asset(
                  AssetsConst.dbnusNoImageLogo,
                  width: widget.width,
                  height: widget.height,
                )
            : SizedBox(
                width: widget.width ?? widget.height,
                height: widget.height ?? widget.width,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    HtmlElementView.fromTagName(
                      tagName: 'img',
                      onElementCreated: (Object element) {
                        try {
                          final imageElement = element as web.HTMLImageElement;
                          imageElement.src = widget.url;
                          imageElement.style.width = widget.width != null
                              ? '${widget.width}px'
                              : 'auto';
                          imageElement.style.height = widget.height != null
                              ? '${widget.height}px'
                              : 'auto';
                          imageElement.style.marginLeft = 'auto';
                          imageElement.style.marginRight = 'auto';
                          imageElement.style.display = 'block';
                          imageElement.style.position =
                              'absolute'; // Add for centering
                          imageElement.style.top = '50%'; // Add for centering
                          imageElement.style.left = '50%'; // Add for centering
                          imageElement.style.transform =
                              'translate(-50%, -50%)'; // Add for centering
                          imageElement.style.objectFit =
                              _getObjectFit(widget.fit);
                          imageElement.draggable = false;

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
                        } catch (e, s) {
                          AppLog.e(e.toString(),
                              error: e,
                              stackTrace: s,
                              tag: "Failed to load image");
                        }
                      },
                    ),
                    const Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
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
        return 'fit-width';
      case BoxFit.fitHeight:
        return 'fit-height';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
      default:
        return 'contain'; // Default value in case fit is null
    }
  }
}
