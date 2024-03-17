import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../main_app.dart';
import '../main_web.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(kIsWeb ? const MyWebApp() : const MyApp());
  });
}
