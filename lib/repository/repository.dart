import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nhs_pedometer/constants/shared_pref_key.dart';
import 'package:nhs_pedometer/model/step.dart';
import 'package:nhs_pedometer/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Repository { 
  Future<void> addUser(User user);
  Future<void> addDailySteps(Step step);
}

class FirestoreRepository extends Repository {
  @override
  Future<void> addUser(User user) async {
    final users = FirebaseFirestore.instance.collection('users');
    users.doc(user.email).set(user.toJson())
      .then((_) => print('User was added'))
      .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Future<void> addDailySteps(Step step) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(SharedPrefKey.email);
    final stepsList = [step.toJson()];
    final steps = FirebaseFirestore.instance.collection('steps');
    final dataEntry = {
      '${step.date.year}-${step.date.month}': FieldValue.arrayUnion(stepsList)
    };
    steps.doc(email).update(dataEntry)
        .then((_) => print('daily step added'))
        .catchError((error) {
          // Handle if update failed, create a new document
          steps.doc(email).set(dataEntry)
              .then((value) => print('daily step record created'))
              .catchError((error) => print('fail to create new document'));
        });
  }
  
}