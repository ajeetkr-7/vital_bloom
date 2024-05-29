import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/locator.dart';
import 'app.dart';
import 'locator.dart' as di;
import 'screens/auth/bloc/user_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.setup();
  runApp(bootStrappedApp(child: const MainApp()));
}

/// bootstraps the application with all the required injections over the app
Widget bootStrappedApp({required Widget child}) {
  return MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => getit<UserBloc>()..loadUser(),
      lazy: false,
    )
  ], child: child);
}
