import 'package:flutter/material.dart';

import 'colors_constant.dart';

ThemeData updateTheme = ThemeData(
  useMaterial3: true,
  // brightness: Brightness.dark,
  // primaryColor: Color.fromRGBO(19, 19, 17, 255),
  // scaffoldBackgroundColor: Color.fromRGBO(19, 19, 17, 255),
  fontFamily: 'Inter',
);

ThemeData appPrimaryTheme = updateTheme.copyWith(
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: TextColor.orange, selectionColor: TextColor.orange, selectionHandleColor: TextColor.orange),
  // scaffoldBackgroundColor: BackgroundColor.white,
  // iconTheme: const IconThemeData(),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: TextColor.darkGrey),
    errorStyle: TextStyle(
      color: ErrorColor.red,
      fontSize: 12,
    ),
    errorMaxLines: 4,
    fillColor: BackgroundColor.white,
    contentPadding: EdgeInsets.all(10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: BorderColor.lightGrey,
        width: 0.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: BorderColor.orange,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ErrorColor.red,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ErrorColor.red,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
