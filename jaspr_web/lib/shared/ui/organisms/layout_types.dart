enum MainAxisAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum CrossAxisAlignment {
  start,
  end,
  center,
  stretch,
  baseline,
}

enum MainAxisSize {
  max,
  min,
}

enum Axis {
  horizontal,
  vertical,
}

class EdgeInsets {
  final double top;
  final double right;
  final double bottom;
  final double left;

  const EdgeInsets.all(double value)
      : top = value,
        right = value,
        bottom = value,
        left = value;

  const EdgeInsets.only({
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    this.left = 0.0,
  });

  const EdgeInsets.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  })  : top = vertical,
        bottom = vertical,
        left = horizontal,
        right = horizontal;

  const EdgeInsets.fromLTRB(this.left, this.top, this.right, this.bottom);

  static const EdgeInsets zero = EdgeInsets.all(0.0);

  @override
  String toString() => '${top}px ${right}px ${bottom}px ${left}px';
}

class BorderRadius {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const BorderRadius.all(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomLeft = radius,
        bottomRight = radius;

  const BorderRadius.only({
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomLeft = 0.0,
    this.bottomRight = 0.0,
  });

  const BorderRadius.circular(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomLeft = radius,
        bottomRight = radius;

  static const BorderRadius zero = BorderRadius.all(0.0);

  @override
  String toString() {
    return '${topLeft}px ${topRight}px ${bottomRight}px ${bottomLeft}px';
  }
}

class BorderSide {
  final double width;
  final String style;
  final String color;

  const BorderSide({
    this.width = 1.0,
    this.style = 'solid',
    this.color = 'black',
  });
}

class Border {
  final BorderSide? top;
  final BorderSide? right;
  final BorderSide? bottom;
  final BorderSide? left;

  const Border({
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  Border.all({
    double width = 1.0,
    String style = 'solid',
    String color = 'black',
  })  : top = BorderSide(width: width, style: style, color: color),
        right = BorderSide(width: width, style: style, color: color),
        bottom = BorderSide(width: width, style: style, color: color),
        left = BorderSide(width: width, style: style, color: color);
}

class BoxShadow {
  final String color;
  final double blurRadius;
  final double spreadRadius;
  final double offsetDx;
  final double offsetDy;

  const BoxShadow({
    this.color = 'rgba(0, 0, 0, 0.1)',
    this.blurRadius = 0.0,
    this.spreadRadius = 0.0,
    this.offsetDx = 0.0,
    this.offsetDy = 0.0,
  });

  @override
  String toString() {
    return '${offsetDx}px ${offsetDy}px ${blurRadius}px ${spreadRadius}px $color';
  }
}

class BoxDecoration {
  final String? color;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const BoxDecoration({
    this.color,
    this.border,
    this.borderRadius,
    this.boxShadow,
  });
}

enum Alignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

