import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nhs_pedometer/main/components/breakdown_widget.dart';
import 'package:nhs_pedometer/main/components/header_title.dart';
import 'package:nhs_pedometer/main/components/headerbar.dart';
import 'package:nhs_pedometer/main/components/steps_widget.dart';
import 'package:nhs_pedometer/utils/converter.dart';
import 'package:nhs_pedometer/utils/disposablewidget.dart';
import 'package:pedometer/pedometer.dart';
import 'package:nhs_pedometer/utils/duration_formatter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with DisposableWidget {
  String _status;
  String _steps = '';
  String _distance = '';
  String _calories = '';
  Duration _time = Duration();
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    setState(() => _status = '');
    Pedometer.stepCountStream
      .listen((event) {
        setState(() => _steps = '${event.steps}');
        setState(() => _distance = Converter.stepsToKm(event.steps)
            .toStringAsPrecision(2));
        setState(() => _calories = Converter.stepsToCalories(event.steps)
            .toStringAsPrecision(2));
      }, onError: (error) {
        print('onStepCountError: $error');
        setState(() => _steps = '--');
      })
      .canceledBy(this);

    Pedometer.pedestrianStatusStream
      .listen((event) {
        setState(() => _status = event.status);
      }, onError: (error) {
        setState(() => _status = 'Unknown');
      })
      .canceledBy(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        brightness: Brightness.dark,
      ),
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
        HeaderBar(height: MediaQuery.of(context).size.height * 0.78),
        Container(
          height: MediaQuery.of(context).size.height * 0.68,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
