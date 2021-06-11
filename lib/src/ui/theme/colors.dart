import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._instanciate();

  static final primary = Colors.lightGreenAccent;
  static final background = Colors.black;
  static final surface = Colors.black12;

  var white = Color.fromRGBO(255, 255, 255, 100);
  var red = Color.fromRGBO(232, 0, 0, 100);
  var green = Color.fromRGBO(66, 255, 0, 100);
  var yellow = Color.fromRGBO(255, 214, 0, 100);
  var black = Color.fromRGBO(0, 0, 0, 100);
  var lightGray = Color.fromRGBO(196, 196, 196, 50);
  var darkGray = Color.fromRGBO(38, 38, 48, 100);

  AppColors();
}
