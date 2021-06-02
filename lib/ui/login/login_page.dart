import 'package:flutter/material.dart';
import 'package:nhs_pedometer/repository/repository.dart';
import 'package:nhs_pedometer/utils/authentication.dart';
import 'components/fb_button.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = LoginController(FirestoreRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Text('SKIP', style: TextStyle(color: Colors.black)),
            iconSize: 40,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Ink(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22),
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/walking_vector.png')
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            'Sign in for Pedometer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Save daily steps, view your history, compete with others, and more.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 150),
              FBButton(onPressed: () {
                final auth = Authentication();
                auth.signInFB().then((user) {
                  _controller.addUser(user).then((value) {
                    Navigator.of(context).pop();
                  });
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
