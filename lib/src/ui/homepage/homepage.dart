import 'package:carbonitor/src/cubits/measurement_cubit.dart';
import 'package:carbonitor/src/cubits/measurement_state.dart';
import 'package:carbonitor/src/cubits/today_cubit.dart';
import 'package:carbonitor/src/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Return State
    return _HomeWidgetContent();
  }
}

class _HomeWidgetState extends StatelessWidget {
  const _HomeWidgetState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TodayCubit(),
        child: BlocBuilder<MeasurementCubit, MeasurementState>(
            builder: (context, state) {
          return _HomeWidgetContent(key: key);
        }));
  }
}

class _HomeWidgetContent extends StatelessWidget {
  static var ac = new AppColors();

  const _HomeWidgetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Container(
        color: ac.darkGray,
        child: ListView(
          children: <Widget>[
            ListView.builder(
                itemCount: 4, //TODO Code dynamical
                padding: EdgeInsets.only(left: 20, right: 20),
                shrinkWrap: true,
                itemBuilder: (context, index) {
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
                                  "Classroom no. 605",
                                  style: TextStyle(
                                    fontSize: 21,
                                  ),
                                ), // TODO Code Dynamical
                                Text(
                                  "22:06",
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
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 10),
                                    decoration: BoxDecoration(
                                      color: ac.green,
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    child: Center(
                                      child: Text("25% - CO2",
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
                }),
          ],
        ),
      ),
    );
  }
}
