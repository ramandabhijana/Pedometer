import 'package:flutter/material.dart';

class StepsWidget extends StatelessWidget {
  final String step;

  const StepsWidget({Key key, this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/logo_white.png', scale: 10),
        const SizedBox(height: 18),
        Text(
          step,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 72
          ),
        ),
        Text(
          'STEPS',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
