import 'package:nhs_pedometer/model/step.dart';
import 'package:nhs_pedometer/repository/repository.dart';

class MainController {
  final Repository _repository;

  MainController(this._repository);

  Future<void> saveDailyStep(DateTime date, int count) {
    final step = Step(date, count);
    return _repository.addDailySteps(step);
  }
}