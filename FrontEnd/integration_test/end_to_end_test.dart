import 'package:dbnus/main.dart' as app;
import 'package:dbnus/router/router_name.dart';
import 'package:dbnus/utils/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('case(1)', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Wait until the "account" text appears
    await pumpUntilFound(tester, find.text("TextUtils.account"));
    // expect(find.text('Page 2'), findsOneWidget);
    // expect(find.text('Page 2'), findsNothing);

    // Tap the FAB to go to Page 2
    // await tester.tap(find.byKey(ValueKey(TextUtils.account)));
    await tester.pumpAndSettle();

    // Is Login Page
    if (
        isFound(tester, find.text(TextUtils.enter_your_mobile_number))) {
      await tester.enterText(
          find.byKey(ValueKey('login_mobile_text_field')), '8000000040');
      await tester.pumpAndSettle();

      await tester.tap(find.text("TextUtils.login_with_code"));
      await tester.pumpAndSettle();

      /*final Finder otpFieldFinder = find.byType(PinCodeTextField);
      await tester.enterText(otpFieldFinder, '55555');
      await tester.pump(Duration(seconds: 1));
      await tester.pump(Duration(seconds: 1));*/
      await tester.enterText(find.byType(PinCodeTextField), '55555');
      await tester.pumpAndSettle(Duration(seconds: 2));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(seconds: 2));

      await tester.tap(find.text(TextUtils.login));
      await tester.pumpAndSettle();
    }
    expect(find.byKey(Key("RouteName.menu")), findsOneWidget);
  });
}

Future<void> pumpUntilFound(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 10)}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pumpAndSettle();
    if (finder.evaluate().isNotEmpty) return;
  }
}

bool isFound(WidgetTester tester, Finder finder) {
  return finder.evaluate().isNotEmpty;
}
