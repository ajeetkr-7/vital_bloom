import 'package:easy_context/easy_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vital_bloom/common_widgets/buttons.dart';
import 'package:vital_bloom/locator.dart';
import 'package:vital_bloom/models/user.dart';
import 'package:vital_bloom/screens/home/bloc/uesr_state.dart';
import 'package:vital_bloom/screens/home/bloc/user_bloc.dart';
import 'package:vital_bloom/utils/colors.dart';

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

  String getABSIText(double value) {
    if (value < -0.272) {
      return "Low Mortality Risk";
    } else if (value >= -0.272 && value < 0.229) {
      return "Average Mortality Risk";
    } else
      return "High Mortality Risk";
  }

  _buildDashboard(Map<String, dynamic> data) {
    final healthScore = data['score'] * 10;
    // data.remove('score');
    final data2 = data.map((key, value) => MapEntry(key, value * 10));
    if (data2.containsKey('score')) data2.remove('score');
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          6.width,
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              widget.user.picture,
              height: 36,
              width: 36,
              fit: BoxFit.cover,
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.user.name}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${widget.user.email}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          CircularIconButton(onPressed: () {}, icon: Icons.search)
        ]),
      ),
      body: SingleChildScrollView(
        primary: true,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Column(
          children: [
            Container(
              height: 230,
              padding: EdgeInsets.all(12),
              width: context.width,
              decoration: BoxDecoration(
                color: AppColors.lightBlue.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SfRadialGauge(
                  title: GaugeTitle(
                      text: 'Health Score',
                      alignment: GaugeAlignment.center,
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  enableLoadingAnimation: true,
                  axes: <RadialAxis>[
                    RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        minimum: 0,
                        maximum: 100,
                        startAngle: 270,
                        endAngle: 270,
                        ranges: <GaugeRange>[
                          GaugeRange(
                            startValue: 0,
                            endValue: 100,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          // GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
                        ],
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: healthScore,
                            gradient: SweepGradient(
                              colors: [
                                Color.fromARGB(255, 83, 8, 163),
                                Colors.blue,
                              ],
                              stops: [0.25, 0.75],
                              center: Alignment.center,
                            ),
                          ),
                          // NeedlePointer(
                          //   value: 90,
                          //   needleLength: 0.75,
                          // )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Container(
                                  child: Text(
                                      (((healthScore * 1.0 as double) * 100)
                                                  .round() /
                                              100)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold))),
                              angle: 90,
                              positionFactor: 0.1)
                        ])
                  ]),
            ),
            20.height,
            GridView.count(
              primary: false,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
                Card(
                  color: AppColors.lightBlue.withOpacity(0.45),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    width: context.width / 2.1,
                    height: context.width / 2.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABSI - Z Score',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text((((data2['absi_z_score'] * 1.0 as double) * 100)
                                    .round() /
                                100)
                            .toString()),
                        Text(getABSIText(
                            (((data2['absi_z_score'] * 1.0 as double) * 100)
                                    .round() /
                                100)))
                      ],
                    ),
                  ),
                ),
                Card(
                  color: AppColors.lightBlue.withOpacity(0.45),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    width: context.width / 2.1,
                    height: context.width / 2.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Life Lost',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text((((data2['total_life_lost'] * 1.0 as double) * 100)
                                    .round() /
                                100)
                            .toString()),
                        // Text(getABSIText(
                        //     (((data2['total_life_lost'] * 1.0 as double) * 100)
                        //             .round() /
                        //         100)))
                      ],
                    ),
                  ),
                ),
                Card(
                  color: AppColors.lightBlue.withOpacity(0.45),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    width: context.width / 2.1,
                    height: context.width / 2.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waist/Hip Ratio',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text((((data2['whr'] * 1.0 as double) * 100).round() /
                                100)
                            .toString()),
                        Text(getWHRText(
                                ((data2['whr'] * 1.0 as double) * 100).round() /
                                    100)
                            .toString()),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: AppColors.lightBlue.withOpacity(0.45),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    width: context.width / 2.1,
                    height: context.width / 2.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OSA Score',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text((((data2['osa_score'] * 1.0 as double) * 100)
                                    .round() /
                                100)
                            .toString()),
                        Text(getOsa(
                            (((data2['osa_score'] * 1.0 as double) * 100)
                                    .round() /
                                100)))
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String getWHRText(double d) {
    if (d > 0.5) {
      return "High Risk of Several Chronic diseases";
    } else {
      return "Low Risk of Chronic diseases";
    }
  }

  String getOsa(double d) {
    if (d >= 0 && d <= 2) {
      return "Low Risk of Obstructive Sleep Apnea";
    } else if (d > 2 && d <= 5) {
      return "No risk of Obstructive Sleep Apnea";
    } else {
      return "High Risk of Obstructive Sleep Apnea";
    }
  }
}
