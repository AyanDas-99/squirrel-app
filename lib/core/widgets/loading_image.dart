import 'package:flutter/material.dart';

class LoadingImage extends StatelessWidget {
  const LoadingImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/magnifier.gif", width: 100,);
  }
}
