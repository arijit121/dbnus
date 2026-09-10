import 'package:jaspr/jaspr.dart';
import '../../enums/language_enum.dart';

class LocalizationProvider extends InheritedComponent {
  final Locale locale;
  final void Function(Locale) onChangeLocale;

  const LocalizationProvider({
    required this.locale,
    required this.onChangeLocale,
    required super.child,
    super.key,
  });

  static LocalizationProvider? of(BuildContext context) {
    return context.dependOnInheritedComponentOfExactType<LocalizationProvider>();
  }

  @override
  bool updateShouldNotify(covariant LocalizationProvider oldComponent) {
    return oldComponent.locale != locale;
  }
}
