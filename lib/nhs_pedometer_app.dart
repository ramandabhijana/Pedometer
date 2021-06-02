import 'package:flutter/material.dart';
import 'package:nhs_pedometer/ui/drawer/drawer_state_manager.dart';
import 'package:nhs_pedometer/ui/main/main_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

class NHSPedometerApp extends StatelessWidget {
  NHSPedometerApp({Key key}) : super(key: key);

  static const Color primaryColor = Color(0xFF0072CE);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) print('Something went wrong');
        if (snapshot.connectionState == ConnectionState.done)
          return MultiProvider(
            child: MaterialApp(
              title: 'NHS Pedometer',
              initialRoute: '/main',
              theme: _themeData(),
              routes: {
                '/main': (_) => MainPage()
              },
            ),
            providers: [
              ChangeNotifierProvider(create: (_) => DrawerStateManager())
            ],
          );
        return CircularProgressIndicator();
      },
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


