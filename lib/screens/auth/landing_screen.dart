import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/utils/colors.dart';

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
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoute.login);
              },
              child: Text(
                'Get Started',
                style: TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
