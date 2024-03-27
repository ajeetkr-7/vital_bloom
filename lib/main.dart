import 'package:flutter/material.dart';
import 'app.dart';
import 'locator.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.setup();
  runApp(bootStrappedApp(child: const MainApp()));
}

/// bootstraps the application with all the required injections over the app
Widget bootStrappedApp({required Widget child}) {
  return child;
}
