import 'package:flutter/material.dart';
import 'package:nhs_pedometer/main/main_page.dart';

class NHSPedometerApp extends StatelessWidget {
  const NHSPedometerApp({Key key}) : super(key: key);

  static const Color primaryColor = Color(0xFF0072CE);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NHS Pedometer',
      home: MainPage(),
      theme: _themeData(),
    );
  }

  ThemeData _themeData() {
    final base = ThemeData.light();
    return base.copyWith(
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      textTheme: base.textTheme.copyWith().apply(
        fontFamily: 'Futura',
      ),
    );
  }
}


