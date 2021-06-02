import 'package:nhs_pedometer/model/user.dart';
import 'package:nhs_pedometer/repository/repository.dart';

class LoginController {
  final Repository _repository;

  LoginController(this._repository);

  Future<void> addUser(User user) {
    return _repository.addUser(user);
  }
}