import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';
import '../atoms/custom_button.dart';

class ErrorWidget extends StatelessComponent {
  final String? message;
  final void Function()? onRetry;

  const ErrorWidget({this.message, this.onRetry, super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'error-container', [
      div(classes: 'error-icon', [text('⚠️')]),
      h3([text('Oops!')]),
      p(classes: 'error-msg', [text(message ?? 'Something went wrong')]),
      if (onRetry != null)
        CustomButton(label: 'Retry', onPressed: onRetry),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.error-container').styles(
      display: .flex,
      flexDirection: .column,
      alignItems: .center,
      justifyContent: .center,
      padding: .all(40.px),
      gap: Gap.all(12.px),
      raw: {'text-align': 'center', 'min-height': '300px'},
    ),
    css('.error-icon').styles(fontSize: 48.px),
    css('.error-msg').styles(color: secondaryDark, fontSize: 14.px),
  ];
}
