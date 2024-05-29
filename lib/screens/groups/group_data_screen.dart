import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vital_bloom/common_widgets/buttons.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/screens/groups/bloc/group_bloc.dart';
import 'package:vital_bloom/screens/groups/bloc/group_state.dart';
import 'package:vital_bloom/utils/colors.dart';
import '../../core/routes/routes.dart';
import '../../models/user.dart';

class GroupDataScreen extends StatefulWidget {
  final User user;
  static Widget withCubit({required User user, required String groupId}) {
    return BlocProvider(
      create: (context) =>
          GroupBloc(authService: getit())..loadGroup(user.id, groupId),
      child: GroupDataScreen(user: user),
    );
  }

  const GroupDataScreen({super.key, required this.user});

  @override
  State<GroupDataScreen> createState() => _GroupDataScreenState();
}

class _GroupDataScreenState extends State<GroupDataScreen> {
  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  _groupboard(Map<String, dynamic> data) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Family Group',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      CircularIconButton(
                          onPressed: () {
                            _launchUrl('http://bit.ly/healthBOT');
                          },
                          icon: Icons.android_rounded),
                      Text('Chat Bot')
                    ],
                  )
                ],
              ),
              6.height,
              // Text('"${data['name']}"', style: TextStyle(fontSize: 18)),
              data['members'].length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.height,
                        Text(
                          'Members:',
                          style: TextStyle(fontSize: 18),
                        ),
                        12.height,
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1.5),
                          shrinkWrap: true,
                          itemCount: data['members'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoute.groupMemberData,
                                  arguments:
                                      User.fromJson(data['members'][index]),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlue.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    data['members'][index]['name'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  )),
                            );
                          },
                        ),
                      ],
                    )
                  : Text('No members in the group'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
      if (state is GroupUninitialized || state is GroupLoading)
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      else if (state is GroupLoaded) {
        return _groupboard(state.data);
      } else if (state is GroupError) {
        return Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.message),
              ElevatedButton(
                style: primaryButtonStyle(),
                onPressed: () {
                  context
                      .read<GroupBloc>()
                      .loadGroup(widget.user.id, widget.user.groupId!);
                },
                child: Text(
                  'Retry',
                ),
              ),
            ],
          ),
        ));
      }
      return Scaffold(
        body: Center(
          child: Text('Invalid Dashboard State'),
        ),
      );
    });
  }
}
