import 'package:flutter/material.dart';
import 'package:vital_bloom/screens/auth/launch_screen.dart';
import 'package:vital_bloom/screens/home/home_navigation_wrapper.dart';
import '../../common_widgets/navigation_error.dart';
import '../../models/user.dart';
import '../../screens/auth/landing_screen.dart';

class AppRoute {
  static const String landing = 'landing';
  static const String launch = '/';
  static const String home = 'home';
  static const String profile = 'profile';

  // onGenerate function
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case launch:
        return MaterialPageRoute(builder: (_) => const LaunchScreen());
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case home:
        final u = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => HomeNavigationWrapper(user: u));
      default:
        return MaterialPageRoute(builder: (_) => const NavigationErrorPage());
    }
  }
}
