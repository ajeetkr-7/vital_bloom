import 'package:flutter/material.dart';
import 'package:vital_bloom/core/routes/routes.dart';
import 'package:vital_bloom/models/user.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Vital Bloom'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Text - "Yayy! Welcome to Vital Bloom"
              Text(
                'Yayy! Welcome to Vital Bloom',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.questionnaire,
                      (route) => false,
                    );
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                      color: AppColors.lightBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )),
            ],
          )),
    );
  }
}
