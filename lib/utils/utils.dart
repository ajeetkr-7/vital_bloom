import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

/// class to manage the widget related functions such as ShowDialog, ShowToast, etc.
class WidgetUtils {
  static void customSnackBar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    Color textColor = AppColors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
    ));
  }
}

/// kept as a first order function to run on a separate thread
Future<Map<String, dynamic>> fixture(String name) async {
  String data = await rootBundle.loadString('assets/fixtures/$name');
  final jsonResult = json.decode(data) as Map<String, dynamic>;
  return jsonResult;
}
