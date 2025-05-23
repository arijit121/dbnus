import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web/web.dart' as web;
import 'package:web/web.dart';
import '../../const/assects_const.dart';
import '../../extension/logger_extension.dart';
import '../../service/value_handler.dart';
import 'dart:js' show allowInterop;

class NetworkImg extends StatelessWidget {
  const NetworkImg(
      {super.key,
      required this.url,
      this.height,
      this.width,
      this.fit,
      this.color,
      this.errorWidget,
      this.loadingWidget});

  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final Widget? loadingWidget, errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
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
                color: Colors.white, // Shimmer background color
              ),
            );
      },
      errorWidget: (_, __, ___) {
        return LayoutBuilder(builder: (context, BoxConstraints constraints) {
          double calculatedWidth = width ??
              (constraints.minWidth != 0
                  ? constraints.minWidth
                  : constraints.maxWidth != double.infinity
                      ? constraints.maxWidth
                      : 0);
          double calculatedHeight = height ??
              (constraints.minHeight != 0
                  ? constraints.minHeight
                  : constraints.maxHeight != double.infinity
                      ? constraints.maxHeight
                      : 0);
          return _CorsNetworkImg(
            key: Key("$constraints"),
            url: url,
            width: calculatedWidth != 0 ? calculatedWidth : null,
            height: calculatedHeight != 0 ? calculatedHeight : null,
            fit: fit,
            color: color,
            errorWidget: errorWidget,
          );
        });
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
      {super.key,
      required this.url,
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
  web.HTMLImageElement? _imageElement;

  @override
  void deactivate() {
    if (_imageElement != null) {
      _imageElement!.onerror = null;
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_imageElement != null) {
      _imageElement!.remove(); // Remove the element from the DOM
      _imageElement = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: errorFound,
      builder: (BuildContext context, bool value, _) {
        return value || !ValueHandler().isTextNotEmptyOrNull(widget.url)
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
                          _imageElement = imageElement;
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
                          imageElement.onerror = allowInterop((Event event) {
                            errorFound.value = true;

                            AppLog.e(widget.url, tag: "Failed to load image");
                          }) as OnErrorEventHandler;

                          // Apply CSS color filter if color is provided
                          if (widget.color != null) {
                            final hsvColor = HSVColor.fromColor(widget.color!);
                            final hue = hsvColor.hue;
                            final saturation = hsvColor.saturation * 100;
                            final brightness = hsvColor.value * 100;

                            imageElement.style.filter =
                                'sepia(1) hue-rotate(${hue}deg) saturate($saturation%) brightness($brightness%)';
                          }
                        } catch (e, s) {
                          AppLog.e(e.toString(),
                              error: e,
                              stackTrace: s,
                              tag: "HtmlElementView error");
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
        return 'contain'; // Default value in case fit is null
    }
  }
}
