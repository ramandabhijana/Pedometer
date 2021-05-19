import 'package:intl/intl.dart';

class Converter {

  static double stepsToKm(int steps) {
    // Formulae: Steps Taken x 0.00076
    return (steps * 76) / 100000;
  }

  static double stepsToCalories(int steps) {
    // "Most people burn 30-40 calories per 1,000 steps they walk"
    // Formulae: Steps taken x 0.04
    return steps * 0.04;
  }

  static String dateToHeaderDateString(DateTime date) {
    final formatter = DateFormat('EEEE d MMM');
    return formatter.format(date);
  }

}