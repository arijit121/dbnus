// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

// Imports the root component.
import 'app.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultServerOptions);

  // Starts serving the app.
  runApp(
    Document.template(
      name: 'index',
      child: const App(),
    ),
  );
}
