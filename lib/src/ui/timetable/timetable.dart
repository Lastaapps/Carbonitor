import 'package:carbonitor/src/constants/time.dart';
import 'package:carbonitor/src/cubits/measurement_cubit.dart';
import 'package:carbonitor/src/cubits/measurement_state.dart';
import 'package:carbonitor/src/cubits/period_cubit.dart';
import 'package:carbonitor/src/cubits/today_cubit.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/data/measurement.dart';
import 'package:carbonitor/src/ui/theme/colors.dart';
import 'package:carbonitor/src/ui/timetable/compute.dart';
import 'package:carbonitor/src/ui/timetable/dataset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/standalone.dart';

final ac = new AppColors();

class TimetableWidget extends StatelessWidget {
  const TimetableWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TimetableWidgetState();
  }
}

class _TimetableWidgetState extends StatelessWidget {
  const _TimetableWidgetState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PeriodCubit(),
        //PeriodCubit(start: TZDateTime(CET, 2020, 9, 21), end: TZDateTime(CET, 2020, 9, 28) ),
        child: BlocBuilder<PeriodCubit, MeasurementState>(
            builder: (context, state) {
          return _TimetableContent(state, key: key);
        }));
  }
}

class _TimetableContent extends StatelessWidget {
  final MeasurementState state;

  const _TimetableContent(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (state is MeasurementData) {
      widget = _TimetableData(state as MeasurementData);
    } else if (state is MeasurementError) {
      widget = Center(
        child: Text("Error..."),
      );
    } else {
      widget = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Timetable"),
      ),
      body: Container(color: ac.darkGray, child: widget),
    );
  }
}

class _TimetableData extends StatelessWidget {
  final MeasurementData state;

  const _TimetableData(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = TZDateTime(CET, 2020, 9, 21, 10, 0);
    final classrooms =
        computeClassrooms(state.classrooms, timetableDataset[0], now);

    return Container(
      color: ac.darkGray,
      child: ListView(
        children: <Widget>[
          ListView.builder(
              itemCount: classrooms.length,
              padding: EdgeInsets.only(left: 20, right: 20),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final classroom = classrooms[index];
                return LessonWidget(classroom, classroom.latest(now));
              }),
        ],
      ),
    );
  }
}

class LessonWidget extends StatelessWidget {
  final Classroom classroom;
  final Measurement measurement;

  const LessonWidget(this.classroom, this.measurement, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color;
    if (measurement.toPercent() <= 25) {
      color = ac.green;
    }
    else if (measurement.toPercent() <= 50) {
      color = ac.yellow;
    }
    else if (measurement.toPercent() <= 75) {
      color = ac.orange;
    } else {
      color = ac.red;
    }
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 20, top: 20),
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: ac.lightGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  height: 50,
                  width: 50,
                  margin:
                  EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text("${measurement.toPercent()}%",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    classroom.name,
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
