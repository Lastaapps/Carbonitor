import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphWidget extends StatelessWidget {
  const GraphWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    // final charts = Chart

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Classroom no. 35"),
            bottom: TabBar(
              tabs: [
                Tab(child: Text("Day")),
                Tab(child: Text("Week")),
                Tab(child: Text("Month"))
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
              child: Container(
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
            ],)
      ),
    );
  }
}
