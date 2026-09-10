// Client-specific Jaspr import.
import 'package:jaspr/client.dart';
import 'main.client.options.dart';

void main() {
  // Initializes the client environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultClientOptions,
  );

  runApp(const ClientApp());
}

