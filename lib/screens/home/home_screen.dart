import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/screens/auth/bloc/uesr_state.dart';
import 'package:vital_bloom/screens/auth/bloc/user_bloc.dart';
import 'package:vital_bloom/screens/auth/launch_screen.dart';
import 'package:vital_bloom/screens/home/dashboard_screen.dart';
import '../../common_widgets/buttons.dart';
import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (!(state is UserAuthenticated)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.landing,
            (route) => false,
          );
        }
      },
      listenWhen: (previous, current) => true,
      builder: (context, state) => !(state is UserAuthenticated)
          ? LaunchScreen()
          : state.user.level == '2'
              ? DashboardScreen.withCubit(
                  user: state.user,
                )
              : SafeArea(
                  child: Scaffold(
                    body: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Large Text - "Yayy! Welcome to Vital Bloom"
                            Text(
                              'Yayy! Welcome to Vital Bloom',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            8.height,
                            // Medium Text - "Hi, ${widtet.user.name}"
                            Text(
                              'Hi, ${widget.user.name}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            20.height,
                            // Small Text - "Level up by taking the questionnaire"
                            Text(
                              'To start tracking you health score complete the following data: ',
                              style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            20.height,
                            ElevatedButton.icon(
                                icon: SizedBox.shrink(),
                                style: primaryButtonStyle(
                                    backgroundColor: state.user.level
                                                    .toString()
                                                    .length >
                                                2 &&
                                            state.user.level.toString()[2] ==
                                                '1'
                                        ? AppColors.green
                                        : AppColors.dark),
                                onPressed: () async {
                                  Navigator.of(context).pushNamed(
                                    AppRoute.questionnaire,
                                    arguments: widget.user,
                                  );
                                },
                                label: Text(
                                  'Take the Questionnaire',
                                  style: TextStyle(
                                      color: AppColors.lightBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                            12.height,
                            ElevatedButton(
                                style: primaryButtonStyle(
                                    backgroundColor:
                                        state.user.level.toString().length >
                                                    2 &&
                                                state.user.level.contains('2')
                                            ? AppColors.green
                                            : AppColors.dark),
                                onPressed: () async {
                                  Navigator.of(context).pushNamed(
                                    AppRoute.physicalDetails,
                                    arguments: widget.user,
                                  );
                                },
                                child: Text(
                                  'Physics Details',
                                  style: TextStyle(
                                      color: AppColors.lightBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                            12.height,
                            ElevatedButton(
                                style: primaryButtonStyle(
                                    backgroundColor:
                                        state.user.level.toString().length >
                                                    2 &&
                                                state.user.level.contains('3')
                                            ? AppColors.green
                                            : AppColors.dark),
                                onPressed: () async {
                                  Navigator.of(context).pushNamed(
                                    AppRoute.jobDetails,
                                    arguments: widget.user,
                                  );
                                },
                                child: Text(
                                  'Work Details',
                                  style: TextStyle(
                                      color: AppColors.lightBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        )),
                  ),
                ),
    );
  }
}
