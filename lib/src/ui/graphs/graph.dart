import 'package:carbonitor/src/constants/time.dart';
import 'package:carbonitor/src/cubits/id_cubit.dart';
import 'package:carbonitor/src/cubits/measurement_state.dart';
import 'package:carbonitor/src/data/measurement.dart';
import 'package:flutter/material.dart';

//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO not working
    final id = ModalRoute.of(context)!.settings.arguments as String;

    return _GraphBlocState(id);
  }
}

class _GraphBlocState extends StatelessWidget {
  final String id;

  const _GraphBlocState(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => IdCubit(id),
        child:
        BlocBuilder<IdCubit, MeasurementState>(builder: (context, state) {
          return _GraphWaitingWidget(state, key: key);
        }));
  }
}

class _GraphWaitingWidget extends StatefulWidget {
  final MeasurementState state;

  const _GraphWaitingWidget(this.state, {Key? key}) : super(key: key);

  @override
  _GraphWaitingWidgetState createState() => _GraphWaitingWidgetState(state);
}

class _GraphWaitingWidgetState extends State<_GraphWaitingWidget> {
  final MeasurementState state;
  int mode = 0;

  _GraphWaitingWidgetState(this.state);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    String label;

    if (state is MeasurementData) {
      widget = _GraphContentWidget(state as MeasurementData, mode);
      label = (state as MeasurementData).classrooms[0].name;
    } else if (state is MeasurementError) {
      widget = Center(
        child: Text("Error"),
      );
      label = "Error";
    } else {
      widget = Center(
        child: CircularProgressIndicator(),
      );
      label = "Loading";
    }

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text(label),
              bottom: TabBar(
                onTap: (index) {
                  setState(() {
                    mode = index;
                  });
                },
                tabs: [
                  Tab(
                    child: Text("Day"),
                  ),
                  Tab(child: Text("Week")),
                  Tab(child: Text("Month"))
                ],
              ),
            ),
            body: widget));
  }
}

class _GraphContentWidget extends StatelessWidget {
  final MeasurementData state;
  final int mode;

  const _GraphContentWidget(this.state, this.mode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allMeasurements = state.classrooms.first.measurements;
    List<List<Measurement>> list;

    switch (mode) {
      case 0:
        list = toDailyMeasurements(allMeasurements, dayStart, dayEnd, true);
        break;
      case 0:
        list = toDailyMeasurements(allMeasurements, weekStart, weekEnd, false);
        break;
      default:
        list =
            toDailyMeasurements(allMeasurements, monthStart, monthEnd, false);
        break;
    }

    return TabBarView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              child: BarChartMain(list, mode),
            )),
      ],
    );
  }
}

class BarChartMain extends StatefulWidget {
  List<List<Measurement>> list;
  int mode;

  BarChartMain(this.list, this.mode);

  @override
  State<StatefulWidget> createState() => BarChartState(list, mode);
}

class BarChartState extends State<BarChartMain> {
  List<List<Measurement>> list;
  int mode;

  BarChartState(this.list, this.mode);

  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 5, 12);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 19, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  makeTransactionsIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Transactions',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'state',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot!.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is PointerExitEvent ||
                                  response.touchInput is PointerUpEvent) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  var sum = 0.0;
                                  for (var rod
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                    sum += rod.y;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(y: avg);
                                    }).toList(),
                                  );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Mn';
                              case 1:
                                return 'Te';
                              case 2:
                                return 'Wd';
                              case 3:
                                return 'Tu';
                              case 4:
                                return 'Fr';
                              case 5:
                                return 'St';
                              case 6:
                                return 'Sn';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '1K';
                            } else if (value == 10) {
                              return '5K';
                            } else if (value == 19) {
                              return '10K';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}

final dayStart = TZDateTime(local, 2020, 9, 21);
final dayEnd = TZDateTime(local, 2020, 9, 22);
final weekStart = TZDateTime(local, 2020, 9, 21);
final weekEnd = TZDateTime(local, 2020, 9, 28);
final monthStart = TZDateTime(local, 2020, 9, 1);
final monthEnd = TZDateTime(local, 2020, 10, 1);

List<List<Measurement>> toDailyMeasurements(
    List<Measurement> data, TZDateTime start, TZDateTime end, bool toHours) {
  final diffDuration =
      !toHours ? Duration.millisecondsPerDay : Duration.millisecondsPerHour;

  final diff = ((end.millisecondsSinceEpoch - start.millisecondsSinceEpoch) /
          diffDuration)
      .round();
  final allDays = List.of([
    for (var i = 0; i < diff; i++)
      TZDateTime.fromMillisecondsSinceEpoch(
          CET, start.millisecondsSinceEpoch + i * diffDuration),
    end
  ]);

  final output = List<List<Measurement>>.generate(
      diff, (index) => List.empty(growable: true));

  for (var i = 0; i < allDays.length - 1; i++) {
    final starting = allDays[i];
    final ending = allDays[i + 1];

    for (var measurement in data) {
      if (measurement.time.isAfter(starting) &&
          measurement.time.isBefore(ending)) {
        final list = output[i];
        list.add(measurement);
      }
    }
  }

  return output;
}
