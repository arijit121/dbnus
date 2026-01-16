import 'package:dbnus/flavors.dart';
import 'package:dbnus/main.dart' as runner;

Future<void> main() async {
  F.appFlavor = Flavor.dev;
  await runner.main();
}
