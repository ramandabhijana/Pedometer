import 'package:flutter/material.dart';

class FBButton extends StatelessWidget {
  final void Function() onPressed;

  static const facebookColor = Color(0xFF4267B2);

  const FBButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(facebookColor),
      ),
      icon: Image.asset(
        'assets/facebook.png',
        scale: 1.5,
      ),
      label: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          'Continue with Facebook',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
