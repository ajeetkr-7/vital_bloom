import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/screens/auth/bloc/user_bloc.dart';
import 'package:vital_bloom/utils/colors.dart';

import 'bloc/uesr_state.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        final userBloc = context.read<UserBloc>();
        final state = userBloc.state;
        if (state is UserAuthenticated) {
          if (state.user.level != "0") {
            Navigator.of(context).pushReplacementNamed(AppRoute.home,
                arguments: state.user);
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoute.fillBio,
                arguments: state.user);
          }
        } else {
          Navigator.pushReplacementNamed(context, AppRoute.landing);
        }
      });
    });
  }

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
          ],
        )),
      ),
    );
  }
}
