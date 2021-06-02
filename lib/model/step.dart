import 'package:nhs_pedometer/utils/converter.dart';

class Step {
  final DateTime date;
  final int count;

  Step(this.date, this.count);

  double get getDistance {
    return Converter.stepsToKm(count);
  }

  double get getCalories {
    return Converter.stepsToCalories(count);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': Converter.yMdDateString(date),
      'count': count,
      'distance': getDistance,
      'caloriesBurned': getCalories,
    };
  }
}