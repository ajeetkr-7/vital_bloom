import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/screens/auth/bloc/uesr_state.dart';
import 'package:vital_bloom/screens/auth/bloc/user_bloc.dart';
import 'package:vital_bloom/screens/auth/launch_screen.dart';
import 'package:vital_bloom/services/auth_service.dart';
import '../../common_widgets/buttons.dart';
import '../../utils/colors.dart';
import 'group_data_screen.dart';

class GroupScreen extends StatefulWidget {
  final User user;
  const GroupScreen({super.key, required this.user});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final usernameController = TextEditingController();
  final usernameFocusNode = FocusNode();

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
          : state.user.groupId != null
              ? GroupDataScreen.withCubit(
                  user: state.user,
                  groupId: state.user.groupId!,
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
                              'You are not in a group yet!',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            8.height,
                            TextFormField(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  usernameFocusNode.requestFocus();
                                  return 'Enter valid name';
                                }
                                return null;
                              },
                              onTapOutside: (event) =>
                                  usernameFocusNode.unfocus(),
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
                                hintText: "Enter the group name",
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
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.dark,
                                      width: 1.2,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.dark,
                                      width: 1.2,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    )),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.transparent,
                                      width: 1,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    )),
                              ),
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
                                  if (usernameController.text.isEmpty) {
                                    usernameFocusNode.requestFocus();
                                    return;
                                  }
                                  final user = await getit<AuthService>()
                                      .createGroup(
                                          name: usernameController.text,
                                          userId: usernameController.text);
                                  context.read<UserBloc>().setUser(user);
                                },
                                label: Text(
                                  'Create the Group',
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
