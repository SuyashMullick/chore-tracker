// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:animate_gradient/animate_gradient.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
      primaryBeginGeometry: const AlignmentDirectional(0, 1),
      primaryEndGeometry: const AlignmentDirectional(0, 2),
      secondaryBeginGeometry: const AlignmentDirectional(2, 0),
      secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
      textDirectionForGeometry: TextDirection.rtl,
      duration: Duration(seconds: 10),
      primaryColors: [
        Color.fromARGB(255, 254, 195, 17),
        Color.fromARGB(255, 255, 157, 10),
      ],
      secondaryColors: [
        Color.fromARGB(255, 133, 24, 147),
        Color.fromARGB(255, 246, 51, 246),
      ],
      child: SizedBox.expand(),
    );
  }
}
