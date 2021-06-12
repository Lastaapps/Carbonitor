import 'package:carbonitor/src/constants/concentrations.dart';
import 'package:carbonitor/src/cubits/measurement_cubit.dart';
import 'package:carbonitor/src/cubits/measurement_state.dart';
import 'package:carbonitor/src/cubits/today_cubit.dart';
import 'package:carbonitor/src/data/classroom.dart';
import 'package:carbonitor/src/data/measurement.dart';
import 'package:carbonitor/src/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HomeWidgetState();
  }
}

class _HomeWidgetState extends StatelessWidget {
  const _HomeWidgetState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TodayCubit(),
        child: BlocBuilder<TodayCubit, MeasurementState>(
            builder: (context, state) {
          return _HomeWidgetContent(state, key: key);
        }));
  }
}

final ac = new AppColors();

class _HomeWidgetContent extends StatelessWidget {
  final MeasurementState state;

  const _HomeWidgetContent(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;

    final dataCubit = BlocProvider.of<TodayCubit>(context);
    dataCubit.fetchData();

    print("Resolving state $state");

    if (state is MeasurementData) {
      widget = _DataWidget(state as MeasurementData);
    } else if (state is MeasurementError) {
      widget = Center(
        child: Text("Error"),
      );
    } else {
      widget = Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Home page"),
        ),
        body: widget);
  }
}

class _DataWidget extends StatelessWidget {
  final MeasurementData state;

  const _DataWidget(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ac.darkGray,
      child: ListView(
        //TODO Implement filter
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    color: ac.lightGray,
                    child: Center(
                      child: Text("Filter:", textAlign: TextAlign.center,),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    color: ac.lightGray,
                    child: Center(
                      child: Text("Filter:", textAlign: TextAlign.center,),
                    ),
                  )
                ],
              ),
            ],
          ),

          ListView.builder(
              itemCount: state.classrooms.length,
              padding: EdgeInsets.only(left: 20, right: 20),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final classroom = state.classrooms[index];

                return _MeasuredItem(classroom);
              })
        ],
      ),
    );
  }
}

class _MeasuredItem extends StatelessWidget {
  final Classroom classroom;
  late final Measurement latest;

  _MeasuredItem(this.classroom, {Key? key}) : super(key: key) {
    latest = classroom.latest(TZDateTime(UTC, 2020, 9, 20));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    classroom.name,
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ), // TODO Code Dynamical
                  Text(
                    "${latest.time.hour}:${latest.time.minute}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      height: 60,
                      width: 100,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        color: ac.green,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Center(
                        child: Text(
                            "${latest.carbon / Concentrations.tiredness.concentration * 100}% - CO2",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            )), // TODO Code Dynamical,
                      )),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
