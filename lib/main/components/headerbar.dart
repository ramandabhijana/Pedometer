import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final double height;

  HeaderBar({
    Key key,
    @required this.height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        color: Color(0xFF0072CE),
        height: height,
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0);
    p.lineTo(size.width, size.height * 0.8);
    p.arcToPoint(
      Offset(0.0, size.height * 0.8),
      radius: const Radius.elliptical(60.0, 25.0),
      rotation: 0.5,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}