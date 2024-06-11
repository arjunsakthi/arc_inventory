import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProgressGIF extends StatelessWidget {
  ProgressGIF({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('asset/loader.gif')),
    ));
  }
}
