import 'package:carbonitor/src/ui/theme/colors.dart';
import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    primaryColor: AppColors.primary,
    backgroundColor: AppColors.background,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.surface,
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
    ),
    // textTheme: GoogleFonts.latoTextTheme(
    //   Theme.of(context).textTheme,
    // ),
    fontFamily: "Test",
  );
}
