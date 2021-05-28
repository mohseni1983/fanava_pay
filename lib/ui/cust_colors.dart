import 'package:flutter/material.dart';

class PColor{
  static const MaterialColor orangeparto = MaterialColor(_orangepartoPrimaryValue, <int, Color>{
    50: Color(0xFFE8EAF6),
    100: Color(0xFFC5CBE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7985CB),
    400: Color(0xFF5C6BC0),
    500: Color(_orangepartoPrimaryValue),
    600: Color(0xFF394AAE),
    700: Color(0xFF3140A5),
    800: Color(0xFF29379D),
    900: Color(0xFF1B278D),
  });
  static const int _orangepartoPrimaryValue = 0xFF3F51B5;

  static const MaterialColor orangepartoAccent =  MaterialColor(_blueAccentValue, <int, Color>{
    100: Color(0xFFC6CBFF),
    200: Color(_blueAccentValue),
    400: Color(0xFF606EFF),
    700: Color(0xFF4757FF),
  });
  static const int _blueAccentValue = 0xFF939DFF;

  static const MaterialColor blueparto = MaterialColor(_redPrimaryValue, <int, Color>{
    50: Color(0xFFF2E4E3),
    100: Color(0xFFDFBAB9),
    200: Color(0xFFCA8D8A),
    300: Color(0xFFB55F5B),
    400: Color(0xFFA53C38),
    500: Color(_redPrimaryValue),
    600: Color(0xFF8D1712),
    700: Color(0xFF82130F),
    800: Color(0xFF780F0C),
    900: Color(0xFF670806),
  });
  static const int _redPrimaryValue = 0xFF951A15;

  static const MaterialColor bluepartoAccent = MaterialColor(_redAccentValue, <int, Color>{
    100: Color(0xFFFF9997),
    200: Color(_redAccentValue),
    400: Color(0xFFFF3431),
    700: Color(0xFFFF1B18),
  });
  static const int _redAccentValue = 0xFFFF6664;
}

/*
static const MaterialColor blue = MaterialColor(_bluePrimaryValue, <int, Color>{
  50: Color(0xFFE8EAF6),
  100: Color(0xFFC5CBE9),
  200: Color(0xFF9FA8DA),
  300: Color(0xFF7985CB),
  400: Color(0xFF5C6BC0),
  500: Color(_bluePrimaryValue),
  600: Color(0xFF394AAE),
  700: Color(0xFF3140A5),
  800: Color(0xFF29379D),
  900: Color(0xFF1B278D),
});
static const int _bluePrimaryValue = 0xFF3F51B5;

static const MaterialColor blueAccent = MaterialColor(_blueAccentValue, <int, Color>{
  100: Color(0xFFC6CBFF),
  200: Color(_blueAccentValue),
  400: Color(0xFF606EFF),
  700: Color(0xFF4757FF),
});
static const int _blueAccentValue = 0xFF939DFF;

static const MaterialColor red = MaterialColor(_redPrimaryValue, <int, Color>{
  50: Color(0xFFF2E4E3),
  100: Color(0xFFDFBAB9),
  200: Color(0xFFCA8D8A),
  300: Color(0xFFB55F5B),
  400: Color(0xFFA53C38),
  500: Color(_redPrimaryValue),
  600: Color(0xFF8D1712),
  700: Color(0xFF82130F),
  800: Color(0xFF780F0C),
  900: Color(0xFF670806),
});
static const int _redPrimaryValue = 0xFF951A15;

static const MaterialColor redAccent = MaterialColor(_redAccentValue, <int, Color>{
  100: Color(0xFFFF9997),
  200: Color(_redAccentValue),
  400: Color(0xFFFF3431),
  700: Color(0xFFFF1B18),
});
static const int _redAccentValue = 0xFFFF6664;
 */