import 'package:flutter/material.dart';
import '../../common_widgets/navigation_error.dart';
import '../../screens/auth/landing_screen.dart';
import '../../screens/auth/login_screen.dart';

class AppRoute {
  static const String home = '/';
  static const String login = 'login';
  static const String profile = 'profile';

  // onGenerate function
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => const NavigationErrorPage());
    }
  }
}
