import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/common_widgets/buttons.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/screens/home/bloc/uesr_state.dart';
import 'package:vital_bloom/screens/home/bloc/user_bloc.dart';

class DashboardScreen extends StatefulWidget {
  final User user;
  const DashboardScreen({super.key, required this.user});

  static Widget withCubit({required User user}) {
    return BlocProvider(
      create: (context) =>
          DashboardBloc(authService: getit())..loadDashboard(user.id),
      child: DashboardScreen(user: user),
    );
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
      if (state is DashboardUninitialized || state is DashboardLoading)
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      else if (state is DashboardLoaded) {
        return _buildDashboard(state.data);
      } else if (state is DashboardError) {
        return Scaffold(
            body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.message),
              ElevatedButton(
                style: primaryButtonStyle(),
                onPressed: () {
                  context.read<DashboardBloc>().loadDashboard(widget.user.id);
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

  _buildDashboard(Map<String, dynamic> data) {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Text('Dashboard Data: $data'),
          ],
        ),
      ),
    );
  }
}
