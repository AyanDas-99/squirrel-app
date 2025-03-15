import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  final double width;
  const LogoImage({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/squirrel.png", width: width);
  }
}
