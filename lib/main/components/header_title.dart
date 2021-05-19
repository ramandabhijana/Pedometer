import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String date;
  final String status;

  const HeaderTitle({
    Key key,
    this.date,
    this.status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            fontSize: 12
          ),
        ),
        const SizedBox(height: 8,),
        Text(
          status,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
