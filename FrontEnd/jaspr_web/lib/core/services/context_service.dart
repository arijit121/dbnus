import 'package:jaspr/jaspr.dart';

class CurrentContext {
  static final CurrentContext _instance = CurrentContext._();
  CurrentContext._();
  factory CurrentContext() => _instance;

  BuildContext? _context;
  BuildContext get context {
    if (_context == null) {
      throw Exception("BuildContext has not been set in CurrentContext.");
    }
    return _context!;
  }
  set context(BuildContext val) => _context = val;
}
