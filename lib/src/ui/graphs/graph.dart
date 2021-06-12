import 'package:carbonitor/src/cubits/id_cubit.dart';
import 'package:carbonitor/src/cubits/measurement_state.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  final MeasurementState state;
  final int mode;

  const _GraphContentWidget(this.state, this.mode, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO filter data based on mode

    return TabBarView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            child: Text("mode: $mode"),
            //   Center(
            //     child: Column(
            //       children: [
            //         Expanded(child: charts.LineChart(
            //
            //     ),)
            // SAVED TODO Complete
            //         ),
            //       ],
            //     ),
            //   ),
          ),
        )
      ],
    );
  }
}
