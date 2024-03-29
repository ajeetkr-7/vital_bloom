import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/common_widgets/buttons.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/services/auth_service.dart';
import 'package:vital_bloom/utils/utils.dart';
import '../../locator.dart';
import '../../utils/colors.dart';
import '../auth/bloc/user_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 30,
          leading: CircularIconButton(
              size: 20,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icons.arrow_back_ios_rounded),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                widget.user.picture,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.user.name}'),
                Text(
                  '${widget.user.email}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )
          ]),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('You are Logged In!'),
            16.height,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  try {
                    await getit<AuthService>().logout();
                    context.read<UserBloc>().clearUser();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.landing,
                      (route) => false,
                    );
                  } catch (e) {
                    WidgetUtils.customSnackBar(context,
                        message: e.toString(), backgroundColor: AppColors.red);
                  }
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                      color: AppColors.lightBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )),
          ],
        )));
  }
}
