import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../organisms/layout_types.dart';

class CustomNetWorkImageView extends StatelessComponent {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double? radius;
  final Color? color;
  final Component? loadingWidget;
  final Component? errorWidget;
  final String? className;
  final Styles? style;

  const CustomNetWorkImageView({
    required this.url,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.radius,
    this.color,
    this.loadingWidget,
    this.errorWidget,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return img(
      classes: className,
      src: url,
      styles: Styles.combine([
        Styles(raw: {
          if (width != null && width != 0.0) 'width': '${width}px',
          if (height != null && height != 0.0) 'height': '${height}px',
          if (radius != null && radius != 0.0) 'border-radius': '${radius}px',
          'object-fit': fit.cssValue,
          if (color != null) 'color': color!.value,
        }),
        if (style != null) style!,
      ]),
    );
  }
}

class CustomAssetImageView extends StatelessComponent {
  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? radius;
  final Color? color;
  final String? className;
  final Styles? style;

  const CustomAssetImageView({
    required this.path,
    this.height,
    this.width,
    this.fit,
    this.radius,
    this.color,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return img(
      classes: className,
      src: path,
      styles: Styles.combine([
        Styles(raw: {
          if (width != null && width != 0.0) 'width': '${width}px',
          if (height != null && height != 0.0) 'height': '${height}px',
          if (radius != null && radius != 0.0) 'border-radius': '${radius}px',
          'object-fit': (fit ?? BoxFit.contain).cssValue,
          if (color != null) 'color': color!.value,
        }),
        if (style != null) style!,
      ]),
    );
  }
}

class CustomSvgAssetImageView extends StatelessComponent {
  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? radius;
  final Color? color;
  final String? className;
  final Styles? style;

  const CustomSvgAssetImageView({
    required this.path,
    this.height,
    this.width,
    this.fit,
    this.radius,
    this.color,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final w = width != null && width != 0.0 ? width! : (height ?? 16.0);
    final h = height != null && height != 0.0 ? height! : (width ?? 16.0);

    if (color != null) {
      return div(
        classes: className,
        styles: Styles.combine([
          Styles(raw: {
            'width': '${w}px',
            'height': '${h}px',
            'min-width': '${w}px',
            'min-height': '${h}px',
            'background-color': color!.value,
            '-webkit-mask-image': 'url("$path")',
            '-webkit-mask-size': (fit ?? BoxFit.contain).cssValue,
            '-webkit-mask-repeat': 'no-repeat',
            '-webkit-mask-position': 'center',
            'mask-image': 'url("$path")',
            'mask-size': (fit ?? BoxFit.contain).cssValue,
            'mask-repeat': 'no-repeat',
            'mask-position': 'center',
            'display': 'inline-block',
            'vertical-align': 'middle',
            if (radius != null && radius != 0.0) 'border-radius': '${radius}px',
          }),
          if (style != null) style!,
        ]),
        [],
      );
    }

    return img(
      classes: className,
      src: path,
      styles: Styles.combine([
        Styles(raw: {
          'width': '${w}px',
          'height': '${h}px',
          'object-fit': (fit ?? BoxFit.contain).cssValue,
          'display': 'inline-block',
          'vertical-align': 'middle',
          if (radius != null && radius != 0.0) 'border-radius': '${radius}px',
        }),
        if (style != null) style!,
      ]),
    );
  }
}

class CustomSvgNetworkImageView extends StatelessComponent {
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? radius;
  final Color? color;
  final String? className;
  final Styles? style;

  const CustomSvgNetworkImageView({
    required this.url,
    this.height,
    this.width,
    this.fit,
    this.radius,
    this.color,
    this.className,
    this.style,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final w = width != null && width != 0.0 ? width! : (height ?? 16.0);
    final h = height != null && height != 0.0 ? height! : (width ?? 16.0);

    if (color != null) {
      return div(
        classes: className,
        styles: Styles.combine([
          Styles(raw: {
            'width': '${w}px',
            'height': '${h}px',
            'min-width': '${w}px',
            'min-height': '${h}px',
            'background-color': color!.value,
            '-webkit-mask-image': 'url("$url")',
            '-webkit-mask-size': (fit ?? BoxFit.contain).cssValue,
            '-webkit-mask-repeat': 'no-repeat',
            '-webkit-mask-position': 'center',
            'mask-image': 'url("$url")',
            'mask-size': (fit ?? BoxFit.contain).cssValue,
            'mask-repeat': 'no-repeat',
            'mask-position': 'center',
            'display': 'inline-block',
            'vertical-align': 'middle',
            if (radius != null && radius != 0.0) 'border-radius': '${radius}px',
          }),
          if (style != null) style!,
        ]),
        [],
      );
    }

    return img(
      classes: className,
      src: url,
      styles: Styles.combine([
        Styles(raw: {
          'width': '${w}px',
          'height': '${h}px',
          'object-fit': (fit ?? BoxFit.contain).cssValue,
          'display': 'inline-block',
          'vertical-align': 'middle',
          if (radius != null && radius != 0.0) 'border-radius': '${radius}px',
        }),
        if (style != null) style!,
      ]),
    );
  }
}

class CustomImage extends StatelessComponent {
  final String src;
  final String? alt;
  final double? width;
  final double? height;
  final String? className;
  final bool rounded;

  const CustomImage({
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.className,
    this.rounded = false,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return img(
      classes: 'custom-img ${rounded ? "img-rounded" : ""} ${className ?? ""}'.trim(),
      src: src,
      alt: alt ?? '',
      styles: Styles(raw: {
        if (width != null) 'width': '${width}px',
        if (height != null) 'height': '${height}px',
      }),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.custom-img').styles(
      raw: {'object-fit': 'cover', 'max-width': '100%'},
    ),
    css('.img-rounded').styles(
      radius: .all(.circular(12.px)),
    ),
  ];
}
