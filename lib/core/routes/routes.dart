import 'package:flutter/material.dart';
import 'package:vital_bloom/screens/auth/launch_screen.dart';
import 'package:vital_bloom/screens/home/home_navigation_wrapper.dart';
import 'package:vital_bloom/screens/profile/fill_bio_screen.dart';
import 'package:vital_bloom/screens/profile/job_details_screen.dart';
import 'package:vital_bloom/screens/profile/physical_details_screen.dart';
import 'package:vital_bloom/screens/profile/questionnaire.dart';
import '../../common_widgets/navigation_error.dart';
import '../../models/user.dart';
import '../../screens/auth/landing_screen.dart';

class AppRoute {
  static const String landing = 'landing';
  static const String launch = '/';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String fillBio = 'fillBio';
  static const String questionnaire = 'questionnaire';
  static const String physicalDetails = 'physicalDetails';
  static const String jobDetails = 'jobDetails';

  // onGenerate function
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case launch:
        return MaterialPageRoute(builder: (_) => const LaunchScreen());
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case home:
        final u = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => HomeNavigationWrapper(user: u));
      case fillBio:
        final u = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => FillBioScreen(user: u));
      case questionnaire:
        final u = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => QuestionnaireScreen(
                  user: u,
                ));
      case physicalDetails:
        final u = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => PhysicalDetailsScreen(
                  user: u,
                ));
      case jobDetails:
        final u = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => JobDetailsScreen(
                  user: u,
                ));
      default:
        return MaterialPageRoute(builder: (_) => const NavigationErrorPage());
    }
  }
}
