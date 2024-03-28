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

  
  ///pop up if needed before exiting any page
  static Future<bool> showDecisionPopup(
      BuildContext context, String title, String message,
      {String allowText = 'Allow', String denyText = 'Deny'}) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            titleTextStyle: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.2),
            contentTextStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.25),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            titlePadding: EdgeInsets.only(top: 24, left: 16, right: 16),
            backgroundColor: Colors.white,
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: AppColors.dark.withOpacity(0.9),
                            strokeAlign: BorderSide.strokeAlignOutside,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    fixedSize: Size(double.infinity, 40),
                  ),
                  child: Text(denyText,
                      style: TextStyle(color: AppColors.dark, fontSize: 14))),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dark,
                    fixedSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  allowText,
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
              )
            ],
          ),
        ) ??
        false;
  }
}

/// kept as a first order function to run on a separate thread
Future<Map<String, dynamic>> fixture(String name) async {
  String data = await rootBundle.loadString('assets/fixtures/$name');
  final jsonResult = json.decode(data) as Map<String, dynamic>;
  return jsonResult;
}
