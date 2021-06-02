import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nhs_pedometer/constants/shared_pref_key.dart';
import 'package:nhs_pedometer/repository/repository.dart';
import 'package:nhs_pedometer/ui/drawer/drawer_widget.dart';
import 'package:nhs_pedometer/ui/login/login_page.dart';
import 'package:nhs_pedometer/ui/main/main_controller.dart';
import 'package:nhs_pedometer/utils/stopwatch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhs_pedometer/utils/converter.dart';
import 'package:nhs_pedometer/utils/disposablewidget.dart';
import 'package:pedometer/pedometer.dart';
import 'package:nhs_pedometer/utils/duration_formatter.dart';
import 'components/breakdown_widget.dart';
import 'components/header_title.dart';
import 'components/headerbar.dart';
import 'components/steps_widget.dart';
import 'package:hive/hive.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with DisposableWidget {
  String _status = '';
  String _steps = '';
  String _distance = '';
  String _calories = '';
  Duration _time = Duration();
  bool _isPaused = false;

  Box _stepsBox = Hive.box('steps');

  StreamSubscription<int> _stopwatchSubscription;
  
  final _controller = MainController(FirestoreRepository());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    checkLoggedIn();
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    setState(() => _status = '');
    Pedometer.stepCountStream
      .listen(_onData, onError: (error) {
        print('onStepCountError: $error');
        setState(() => _steps = '--');
      })
      .canceledBy(this);

    Pedometer.pedestrianStatusStream
      .listen((event) {
        setState(() => _status = event.status);
        if (event.status == 'walking')
          _startStopwatch();
        else if (event.status == 'stopped')
          _stopwatchSubscription.cancel();
      }, onError: (error) {
        setState(() => _status = 'not available');
      })
      .canceledBy(this);
  }

  _startStopwatch() {
    _stopwatchSubscription = StopWatch.stream
        .listen((tick) {
          final int lastTick = _stepsBox.get(SharedPrefKey.lastDuration);
          final currentTick = lastTick + tick;
          _stepsBox.put(SharedPrefKey.lastDuration, currentTick);
          final hours = ((currentTick / 360) % 60).floor();
          final minutes = ((currentTick / 60) % 60).floor();
          final seconds = (currentTick % 60).floor();
          setState(() => _time = Duration(
            hours: hours,
            minutes: minutes,
            seconds: seconds,
          ));
        });
    _stopwatchSubscription.canceledBy(this);
  }

  Future<void> checkLoggedIn() async {
    final loggedIn = await _userIsLoggedIn;
    if (!loggedIn)
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoginPage(),
        fullscreenDialog: true,
      ));
  }

  Future<void> _onData(StepCount stepCount) async {
    int savedSteps = _stepsBox.get(SharedPrefKey.savedSteps, defaultValue: 0);
    
    // Reset savedSteps upon reboot
    if (stepCount.steps < savedSteps) {
      savedSteps = 0;
      _stepsBox.put(SharedPrefKey.savedSteps, savedSteps);
    }
    
    DateTime lastDateSaved = _stepsBox.get(SharedPrefKey.lastDate);
    int lastDurationSaved = _stepsBox.get(SharedPrefKey.lastDuration);

    final DateTime timeStamp = DateTime(
      stepCount.timeStamp.year,
      stepCount.timeStamp.month,
      stepCount.timeStamp.day,
    );
    
    // Initialize on first spin
    if (lastDateSaved == null && lastDurationSaved == null) {
      print('Initializing last date and duration');
      _stepsBox.put(SharedPrefKey.lastDate, timeStamp);
      _stepsBox.put(SharedPrefKey.lastDuration, 0);
    }

    if (lastDateSaved.isBefore(timeStamp)) {
      // Save to firebase if user is logged in
      if (await _userIsLoggedIn)
        _controller.saveDailyStep(
          lastDateSaved,
          _stepsBox.get(SharedPrefKey.dailySteps),
        );

      // Reset
      lastDateSaved = timeStamp;
      savedSteps = stepCount.steps;
      _stepsBox
        ..put(SharedPrefKey.lastDate, lastDateSaved)
        ..put(SharedPrefKey.savedSteps, savedSteps);
    }

    final dailySteps = stepCount.steps - savedSteps;
    setState(() => _steps = '$dailySteps');
    setState(() => _distance = Converter.stepsToKm(dailySteps)
        .toStringAsFixed(2));
    setState(() => _calories = Converter.stepsToCalories(dailySteps)
        .toStringAsFixed(2));
    
    _stepsBox.put(SharedPrefKey.dailySteps, dailySteps);
  }

  Future<bool> get _userIsLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefKey.token) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
      ),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: ListView(
          children: [
            _buildBanner(context),
            const SizedBox(height: 20),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Stack(
      children: [
        HeaderBar(height: MediaQuery.of(context).size.height * 0.7),
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.only(left: 19, right: 19, bottom: 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeaderTitle(
                    date: Converter.dateToHeaderDateString(DateTime.now()).toUpperCase(),
                    status: _status,
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StepsWidget(step: _steps),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BreakdownWidget(value: _distance, name: 'DISTANCE',),
                  BreakdownWidget(value: _time.toHourMinuteSecondFormat, name: 'TIME',),
                  BreakdownWidget(value: _calories, name: 'CALORIES',),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPaused = !_isPaused;
            if (_isPaused) _status = 'paused';
          });
          _isPaused ? cancelSubscriptions() : initPlatformState();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            _isPaused ? 'RESUME' : 'PAUSE',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.list_alt_outlined,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: Icon(
              Icons.settings_applications_outlined,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
