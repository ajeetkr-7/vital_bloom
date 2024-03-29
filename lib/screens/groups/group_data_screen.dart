import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/common_widgets/buttons.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/screens/groups/bloc/group_bloc.dart';
import 'package:vital_bloom/screens/groups/bloc/group_state.dart';

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
  _groupboard(Map<String, dynamic> data) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              12.height,
              Text('Group Name: ${data['name']}'),
              data['members'].length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.height,
                        Text('Members:'),
                        12.height,
                        ListView.builder(
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
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(data['members'][index]['name']),
                              ),
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
