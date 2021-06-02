import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:nhs_pedometer/model/user.dart';
import 'package:nhs_pedometer/utils/pref_repository.dart';

class Authentication {
  final fbLogin = FacebookLogin();

  static const String graphUrl = 'https://graph.facebook.com/v2.12/me?'
      'fields=name,picture.width(200).height(200),'
      'first_name,last_name,email&access_token=';

  Future<User> signInFB() async {
    final result = await fbLogin.logIn(['email']);
    final token = result.accessToken.token;
    final response = await http.get('$graphUrl$token');
    final profile = jsonDecode(response.body);
    final name = profile['name'], email = profile['email'];
    PrefRepository.save(
      name: name,
      email: email,
      imageUrl: profile['picture']['data']['url'],
      token: token,
    );
    return User(name, email);
  }
}