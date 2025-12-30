import 'package:flutter_test/flutter_test.dart';

class IntegrationTestUtils {
  static Future<void> pumpUntilFound(WidgetTester tester, Finder finder,
      {Duration timeout = const Duration(seconds: 10)}) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await tester.pumpAndSettle();
      if (finder.evaluate().isNotEmpty) return;
    }
  }

  static bool isFound(WidgetTester tester, Finder finder) {
    return finder.evaluate().isNotEmpty;
  }
}
