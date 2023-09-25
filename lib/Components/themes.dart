import 'package:flutter/material.dart';

class themes {
  Color PinkCol = const Color(0xffeffcccc);
  Color RedCol = const Color(0xFFff4667);
  Color OrangeCol = const Color(0xCFFF8746);
  Color Pink2Col = const Color(0xffFF92A5);

  ThemeData LightThemes() {
    return ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: PinkCol,
            secondary: PinkCol,
            onSecondary: Colors.black,
            error: Colors.red,
            onError: Colors.red,
            background: Colors.green,
            onBackground: Colors.black,
            surface: PinkCol,
            onSurface: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        timePickerTheme:
            const TimePickerThemeData(backgroundColor: Colors.white),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black, size: 30),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
          headlineLarge: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            color: Colors.grey[600],
            fontSize: 25,
          ),
          headlineSmall: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          bodySmall: const TextStyle(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.black,
        ));
  }

  ThemeData DarkThemes() {
    return ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.white,
            onPrimary: Color.fromARGB(255, 2, 3, 35),
            secondary: Color.fromARGB(255, 2, 3, 35),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.red,
            background: Colors.green,
            onBackground: Colors.white,
            surface: Color.fromARGB(255, 2, 3, 35),
            onSurface: Colors.white),
        scaffoldBackgroundColor: const Color.fromARGB(255, 2, 3, 35),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 2, 3, 35),
          iconTheme: IconThemeData(color: Colors.white, size: 30),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
          headlineLarge: const TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            color: Colors.grey[400],
            fontSize: 25,
          ),
          headlineSmall: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          bodySmall: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ));
  }
}
