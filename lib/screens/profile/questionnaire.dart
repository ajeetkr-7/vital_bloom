import 'dart:convert';

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
  final _questions = [
    // Question 1
    {
      'question': 'Q1. Do you smoke?',
      'options': ['yes', 'no'],
      'type': 'boolean',
      'value': null, // Boolean for yes/no question
    },
    // Question 2 (hidden initially)
    {
      'question': 'Q1.1. How many cigarettes do you smoke per day?',
      'min': 1,
      'max': 10,
      'type': 'slider',
      'value': 1.0, // Double for slider value
    },
    // Question 3 (hidden initially)
    {
      'question': 'Q1.2. At what age did you start smoking?',
      'hint': 'Enter your age',
      'type': 'number',
      'value': '', // String for text input
    },
    {
      "question": "Q2. do you drink?",
      "options": ["yes", "no"],
      "type": "boolean",
      'value': null, // Boolean for yes/no question
    },
    {
      "question":
          "Q3. How often do you work out or perform physical activities?",
      "options": [
        "No activity",
        "Less than once a week",
        "Once a week",
        "Twice a week",
        "3-5 times a week",
        "daily"
      ],
      "type": "radio",
      'value': null, // Boolean for yes/no question
    },
    {
      "question": "Q4. How stressful is your life?",
      'min': 0,
      'max': 10,
      'type': 'slider',
      'value': 0.0, // Boolean for yes/no question
    },
    {
      "question": "Q5. do you feel constantly tired?",
      "options": ["yes", "no"],
      "type": "boolean",
      'value': null, // Boolean for yes/no question
    },
    {
      "question": "Q3.1. exerciseDuration",
      "options": ["< 30 mins", "30-60 mins", "1-2 hours", "> 2 hours"],
      "type": "radio",
      'value': null, // Boolean for yes/no question
    },
    {
      "question": "Q6. sleepAlarmingSign",
      "options": ["yes", "no"],
      "type": "boolean",
      'value': null, // Boolean for yes/no question
    },
    // ... (similar structure for other questions)
    {
      'question': 'Q7. Snoring',
      'options': ['yes', 'no'],
      'type': 'boolean',
      'value': null, // Boolean for yes/no question
    },
  ];

  int getWorkoutFrequency(int value) {
    switch (value) {
      case 0:
        return 0;
      case 1:
        return 15;
      case 2:
        return 30;
      case 3:
        return 55;
      case 4:
        return 80;
      case 5:
        return 100;
      default:
        return 0;
    }
  }

  Future<void> uploadData() async {
    final data = {
      'smoking': (_questions[0]['value'] as int) == 1
          ? 0
          : double.parse(_questions[1]['value'].toString()).toInt(),
      'drinking': _questions[3]['value'] == 0 ? true : false,
      'workoutFrequency': getWorkoutFrequency(_questions[4]['value'] as int),
      'stressLevel': double.parse(_questions[5]['value'].toString()).toInt(),
      'constantlyTired': _questions[6]['value'] == 0 ? true : false,
      'exerciseDuration': (_questions[4]['value'] as int) == 0
          ? 0
          : (_questions[7]['value'] as int),
      'sleepAlarmingSign': _questions[8]['value'] == 0 ? true : false,
      'snoring': _questions[9]['value'] == 0 ? true : false,
    };
    if ((_questions[0]['value'] as int) == 0) {
      data['smokingStartAge'] = int.parse(_questions[2]['value'].toString());
    }

    print(data);
    try {
      final updatedUser = await getit<AuthService>().updateHealthInfo(
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

  FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Health Questionnaire'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                String message = "";
                if (_questions[0]['value'] == null) {
                  message = "Please answer the Q1";
                } else if (_questions[0]['value'] == 0 &&
                    (_questions[1]['value'] == 0)) {
                  message = "Please answer Q1.1";
                } else if (_questions[0]['value'] == 0 &&
                    _questions[2]['value'] == "") {
                  message = "Please answer Q1.2";
                } else if (_questions[3]['value'] == null) {
                  message = "Please answer Q2";
                } else if (_questions[4]['value'] == null) {
                  message = "Please answer Q3";
                } else if (_questions[4]['value'] != 0 &&
                    _questions[7]['value'] == null) {
                  message = "Please answer Q4";
                } else if (_questions[5]['value'] == 0) {
                  message = "Please answer Q5";
                } else if (_questions[6]['value'] == null) {
                  message = "Please answer Q6";
                } else if (_questions[8]['value'] == null) {
                  message = "Please answer Q7";
                } else if (_questions[9]['value'] == null) {
                  message = "Please answer Q8";
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
          child: Column(children: [
            buildRadio(_questions[0]),
            if (_questions[0]['value'] == 0) buildSlider(_questions[1]),
            if (_questions[0]['value'] == 0)
              buildNumber(_questions[2], focusNode2),
            buildRadio(_questions[3]),
            buildRadio(_questions[4]),
            if (_questions[4]['value'] != 0 && _questions[4]['value'] != null)
              buildRadio(_questions[7]),
            buildSlider(_questions[5]),
            buildRadio(_questions[6]),
            buildRadio(_questions[8]),
            buildRadio(_questions[9]),
          ]),
        ));
  }

  Widget buildRadio(Map<String, dynamic> question) => Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget buildSlider(Map<String, dynamic> question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['question'], style: TextStyle(fontSize: 16)),
        Slider(
          value: question['value'],
          min: question['min'].toDouble(),
          max: question['max'].toDouble(),
          divisions: question['max'] - question['min'],
          onChanged: (value) => setState(() => question['value'] = value),
          label: question['value'].round().toString(),
        ),
      ],
    );
  }

  Widget buildNumber(Map<String, dynamic> question, FocusNode focusNode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['question'], style: TextStyle(fontSize: 16)),
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
    );
  }
}
