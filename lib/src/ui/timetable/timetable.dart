import 'package:carbonitor/src/ui/theme/colors.dart';
import 'package:flutter/material.dart';

class TimetableWidget extends StatelessWidget {
  static var ac = new AppColors();

  const TimetableWidget({Key? key}) : super(key: key);

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
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                decoration: BoxDecoration(
                                  color: ac.green,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text("100%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                      )), // TODO Code Dynamical,
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Classroom no. 605",
                                  style: TextStyle(
                                    fontSize: 21,
                                  ),
                                ), // TODO Code Dynamical
                              ],
                            ),
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
