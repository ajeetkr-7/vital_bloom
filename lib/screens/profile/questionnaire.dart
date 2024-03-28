import 'dart:convert';

import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_bloom/core/db/shared_prefs.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/services/auth_service.dart';
import 'package:vital_bloom/utils/colors.dart';
import 'package:vital_bloom/utils/enums.dart';
import '../../core/routes/routes.dart';
import '../../utils/utils.dart';

// class FillBioScreen extends StatefulWidget {
//   const FillBioScreen({super.key});

//   @override
//   State<FillBioScreen> createState() => _FillBioScreenState();
// }

// class _FillBioScreenState extends State<FillBioScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//     );
//   }
// }

class QuestionnaireScreen extends StatefulWidget {
  final User user;
  const QuestionnaireScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  FocusNode usernameFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode weightFocusNode = FocusNode();
  late final TextEditingController usernameController;
  late final TextEditingController ageController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    usernameController = TextEditingController(text: widget.user.name);
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      usernameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      final userName = usernameController.text;
      final age = ageController.text;
      final height = heightController.text;
      final weight = weightController.text;

      try {
        final user = await getit<AuthService>().updateProfile(
            userId: widget.user.id,
            payload: {
              'name': userName,
              'age': age,
              'height': height,
              'weight': weight,
              'sex': 'Male'
            });
        // save in sharedpref
        final res = await getit<SharedPrefs>()
            .setValue(SharedPrefKey.user.toString(), json.encode(user));
        if (res) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoute.home, (route) => false,
              arguments: user);
        }
      } catch (e) {
        WidgetUtils.customSnackBar(context,
            message: e.toString(), backgroundColor: Colors.red);
      }
    }
  }

  // void signUp() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          height: context.height,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    // GestureDetector(
                    //   onTap: () async {
                    //     await popWithExitDialog();
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(
                    //             color: Color(0xFF7e7e7e),
                    //             width: 0.8,
                    //             strokeAlign: BorderSide.strokeAlignOutside),
                    //         borderRadius: BorderRadius.circular(8)),
                    //     padding: EdgeInsets.all(6),
                    //     child: Icon(
                    //       Icons.arrow_back_ios_new_rounded,
                    //       color: AppColors.dark,
                    //       size: 20,
                    //     ),
                    //   ),
                    // ),
                    // 16.width,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        widget.user.picture,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.user.name}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${widget.user.email}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  ]),
                  40.height,
                  Text(
                    'Complete Profile',
                    style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  12.height,
                  Text('Name',
                      style: TextStyle(
                          color: AppColors.dark.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  4.height,
                  TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        usernameFocusNode.requestFocus();
                        return 'Enter valid name';
                      }
                      return null;
                    },
                    onTapOutside: (event) => usernameFocusNode.unfocus(),
                    focusNode: usernameFocusNode,
                    controller: usernameController,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                    ],
                    decoration: InputDecoration(
                      hintText: "Your Name",
                      contentPadding: const EdgeInsets.only(left: 16),
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.grey,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1.2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1.2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                    ),
                  ),
                  12.height,
                  Text('Age',
                      style: TextStyle(
                          color: AppColors.dark.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  4.height,
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        ageFocusNode.requestFocus();
                        return 'enter Age';
                      }
                      return null;
                      // // final emailRegExp =
                      // //     RegExp(r"^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+");
                      // emailFocusNode.requestFocus();
                      // return emailRegExp.hasMatch(value)
                      //     ? null
                      //     : 'enter valid email';
                    },
                    onTapOutside: (event) => ageFocusNode.unfocus(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(3),
                    ],
                    controller: ageController,
                    focusNode: ageFocusNode,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Your Age",
                      contentPadding: const EdgeInsets.only(left: 16),
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.grey,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1.2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                    ),
                  ),
                  12.height,
                  Text('Height',
                      style: TextStyle(
                          color: AppColors.dark.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  4.height,
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        ageFocusNode.requestFocus();
                        return 'enter height';
                      }
                      return null;

                      // // final emailRegExp =
                      // //     RegExp(r"^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+");
                      // emailFocusNode.requestFocus();
                      // return emailRegExp.hasMatch(value)
                      //     ? null
                      //     : 'enter valid email';
                    },
                    onTapOutside: (event) => ageFocusNode.unfocus(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(3),
                    ],
                    controller: heightController,
                    focusNode: heightFocusNode,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Height in cm",
                      contentPadding: const EdgeInsets.only(left: 16),
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.grey,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1.2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                    ),
                  ),
                  12.height,
                  Text('Weight',
                      style: TextStyle(
                          color: AppColors.dark.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  4.height,
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        ageFocusNode.requestFocus();
                        return 'enter Weight';
                      }
                      return null;
                      // // final emailRegExp =
                      // //     RegExp(r"^[a-zA-Z\d.]+@[a-zA-Z\d]+\.[a-zA-Z]+");
                      // emailFocusNode.requestFocus();
                      // return emailRegExp.hasMatch(value)
                      //     ? null
                      //     : 'enter valid email';
                    },
                    onTapOutside: (event) => ageFocusNode.unfocus(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(3),
                    ],
                    controller: weightController,
                    focusNode: weightFocusNode,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Weight in Kg",
                      contentPadding: const EdgeInsets.only(left: 16),
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.grey,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1.2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.dark,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.transparent,
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          )),
                    ),
                  ),
                  // Spacer(),
                  32.height,
                  ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide.none),
                        backgroundColor: AppColors.dark,
                        elevation: 0,
                        fixedSize: Size(context.width, 48),
                        alignment: AlignmentDirectional.center,
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Color(0xFFFCFCFA),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
