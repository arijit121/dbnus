import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';

/// A reusable component that displays a premium loading spinner and message.
class LoadingWidget extends StatelessComponent {
  final String? message;
  final bool fullScreen;
  final String? className;

  const LoadingWidget({
    this.message,
    this.fullScreen = false,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final containerClass = [
      'loading-container',
      if (fullScreen) 'loading-fullscreen',
      if (className != null) className!,
    ].join(' ');

    return div(classes: containerClass, [
      div(classes: 'loading-spinner-wrapper', [
        div(classes: 'loading-spinner-circle', []),
        div(classes: 'loading-spinner-inner', []),
      ]),
      if (message != null)
        p(classes: 'loading-message', [Component.text(message!)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.loading-container').styles(
          display: .flex,
          flexDirection: .column,
          alignItems: .center,
          justifyContent: .center,
          padding: .symmetric(vertical: 40.px, horizontal: 20.px),
          gap: Gap.all(16.px),
          raw: {'transition': 'opacity 0.2s ease'},
        ),
        css('.loading-fullscreen').styles(
          raw: {
            'position': 'fixed',
            'inset': '0',
            'z-index': '9999',
            'background-color': 'rgba(248, 250, 252, 0.85)',
            'backdrop-filter': 'blur(4px)',
          },
        ),
        css('.loading-spinner-wrapper').styles(
          raw: {
            'position': 'relative',
            'width': '50px',
            'height': '50px',
          },
        ),
        css('.loading-spinner-circle').styles(
          width: 100.percent,
          height: 100.percent,
          radius: .all(.circular(50.percent)),
          raw: {
            'border': '4px solid #E2E8F0',
            'border-top-color': '#6C63FF',
            'animation': 'spin 1s linear infinite',
          },
        ),
        css('.loading-spinner-inner').styles(
          width: 50.percent,
          height: 50.percent,
          radius: .all(.circular(50.percent)),
          raw: {
            'position': 'absolute',
            'top': '25%',
            'left': '25%',
            'border': '2px solid transparent',
            'border-bottom-color': '#8B5CF6',
            'animation': 'spin-reverse 1.5s linear infinite',
          },
        ),
        css('.loading-message').styles(
          fontSize: 14.px,
          fontWeight: .w500,
          color: primaryDark,
          margin: .zero,
          raw: {'letter-spacing': '0.02em'},
        ),
        css.keyframes('spin', {
          '0%': Styles(raw: {'transform': 'rotate(0deg)'}),
          '100%': Styles(raw: {'transform': 'rotate(360deg)'}),
        }),
        css.keyframes('spin-reverse', {
          '0%': Styles(raw: {'transform': 'rotate(360deg)'}),
          '100%': Styles(raw: {'transform': 'rotate(0deg)'}),
        }),
      ];
}
