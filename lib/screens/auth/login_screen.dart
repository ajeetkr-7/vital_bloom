import 'package:flutter/material.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/utils/colors.dart';
import 'package:vital_bloom/utils/utils.dart';
import '../../services/auth_service.dart';
import '../profile/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',
            style:
                TextStyle(color: AppColors.black, fontWeight: FontWeight.w500)),
        backgroundColor: AppColors.white,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
        ]),
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
      getit<AuthService>().verifyToken(idToken);
    } catch (e) {
      print(e);
      WidgetUtils.customSnackBar(context,
          message: 'login failed', backgroundColor: AppColors.red);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: user),
      ),
    );
  }
}
