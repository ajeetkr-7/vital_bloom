import 'dart:convert';

import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/services/auth_service.dart';
import 'package:vital_bloom/utils/colors.dart';
import 'package:vital_bloom/utils/enums.dart';
import 'package:vital_bloom/utils/extensions.dart';
import '../../core/db/shared_prefs.dart';
import '../../utils/utils.dart';
import '../auth/bloc/user_bloc.dart';

class JobDetailsScreen extends StatefulWidget {
  final User user;
  const JobDetailsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final _questions = [
    // Question 1
    {
      "question": "Q1. Are you working or studying?",
      "options": ["yes", "no"],
      "type": "boolean",
      'value': null, // Boolean for yes/no question
    },
    {
      'question': 'Q2. your average working/studying hours',
      'min': 1,
      'max': 16,
      'type': 'slider',
      'value': 1.0, // String for text input
    },
    {
      'question': 'Q2. how are you satisfied with your job/study?',
      'min': 0,
      'max': 1,
      'type': 'slider',
      'value': 0.0, // String for text input
    },
  ];

  Future<void> uploadData() async {
    final data = {
      'workStatus': _questions[0]['value'] == 0 ? true : false,
      'workTime': (_questions[0]['value'] as int) == 1
          ? 0
          : double.parse(_questions[1]['value'].toString()).toInt(),
      'satisfaction': (_questions[0]['value'] as int) == 1
          ? 0
          : double.parse(_questions[2]['value'].toString()),
    };

    print(data);
    try {
      final updatedUser = await getit<AuthService>().updateHealthInfo(
        type: 'jobDetails',
        userId: widget.user.id,
        payload: data,
      );
      print(updatedUser);
      await getit<SharedPrefs>()
          .setValue(SharedPrefKey.user.toString(), json.encode(updatedUser));
      context.read<UserBloc>().setUser(updatedUser);
      Navigator.of(context).pop();
    } catch (e) {
      WidgetUtils.customSnackBar(
        context,
        message: e.toString(),
        backgroundColor: AppColors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Proffessional Details'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                String message = "";
                if (_questions[0]['value'] == null) {
                  message = "Please answer the Q1";
                } else if (_questions[0]['value'] == 1 &&
                    _questions[1]['value'] == 0) {
                  message = "Please answer Q2";
                } else if (_questions[2]['value'] == 1 &&
                    _questions[2]['value'] == 0) {
                  message = "Please answer Q3";
                }
                if (message.isNotEmpty) {
                  WidgetUtils.customSnackBar(context,
                      message: message, backgroundColor: AppColors.red);
                  return;
                }
                uploadData();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(children: [
            buildRadio(_questions[0]),
            if (_questions[0]['value'] == 0) buildSlider(_questions[1]),
            if (_questions[0]['value'] == 0)
              buildSlider(_questions[2], divisions: 10),
          ]),
        ));
  }

  Widget buildRadio(Map<String, dynamic> question) => Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: AppColors.lightBlue.withOpacity(0.3),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question['question'], style: TextStyle(fontSize: 16)),
            ...(question['options'] as List<String>)
                .mapIndexed((option, index) => RadioListTile<int>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide.none),
                      splashRadius: 0,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      title: Text(option, style: TextStyle(fontSize: 16)),
                      value: index,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      groupValue: question['value'],
                      onChanged: (value) =>
                          setState(() => question['value'] = value),
                    ))
                .toList(),
          ],
        ),
      );

  Widget buildSlider(Map<String, dynamic> question, {int? divisions}) {
    int div = divisions ?? question['max'] - question['min'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['question'], style: TextStyle(fontSize: 16)),
        Slider(
          value: question['value'],
          min: question['min'].toDouble(),
          max: question['max'].toDouble(),
          divisions: div,
          onChanged: (value) => setState(() => question['value'] = value),
          label: '${(question['value'] * 10).round() / 10}',
        ),
      ],
    );
  }

  Widget buildNumber(Map<String, dynamic> question, FocusNode focusNode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          color: AppColors.lightBlue.withOpacity(0.3),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question['question'], style: TextStyle(fontSize: 16)),
          6.height,
          TextFormField(
            onChanged: (value) => setState(() => question['value'] = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                focusNode.requestFocus();
                return 'enter Age';
              }
              if (value.length != 2 || int.tryParse(value) == null) {
                focusNode.requestFocus();
                return 'We understand, but enter age greater than 10';
              }
              return null;
            },
            onTapOutside: (event) => focusNode.unfocus(),
            focusNode: focusNode,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.number,
            minLines: 1,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: 'Enter Age',
              hintStyle: TextStyle(
                color: Color(
                  0xFFb8b8b8,
                ),
                fontSize: 14,
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.grey,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )),
              contentPadding: EdgeInsets.only(left: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.transparent,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.dark,
                    width: 1.1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
