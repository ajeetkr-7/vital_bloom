import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/utils/colors.dart';
import '../../locator.dart';
import '../../services/auth_service.dart';
import '../../utils/utils.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              // stops: [0.6, 0.8, 0.9],
              colors: [
                AppColors.white,
                AppColors.lightBlue.withOpacity(0.3),
                // AppColors.yellow.withOpacity(0.4),
                AppColors.yellow.withOpacity(0.25),
              ],
              tileMode: TileMode.clamp),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Vital Bloom',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            40.height,
            Text(
              'Hi👋',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkBlue,
              ),
            ),
            Text(
              'Welcome to Vital Bloom!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkBlue,
              ),
            ),
            16.height,
            Text(
              'Your Fitness Journey Begins here',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
            48.height,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: signInWithGoogle,
              child: Text(
                'Sign in With Google',
                style: TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
          ],
        )),
      ),
    );
  }

  
  Future<void> signInWithGoogle() async {
    final user = await getit<AuthService>().login();
    if (user == null) {
      WidgetUtils.customSnackBar(context,
          message: 'login failed', backgroundColor: AppColors.red);
      return;
    }
    final idToken = (await user.authentication).idToken;
    if (idToken == null) {
      WidgetUtils.customSnackBar(context,
          message: 'received token is null', backgroundColor: AppColors.red);
      return;
    }
    try {
      final u = await getit<AuthService>().verifyToken(idToken);
      Navigator.of(context).pushNamed(AppRoute.home, arguments: u);
    } catch (e) {
      print(e);
      WidgetUtils.customSnackBar(context,
          message: 'login failed', backgroundColor: AppColors.red);
      return;
    }
  }
}
