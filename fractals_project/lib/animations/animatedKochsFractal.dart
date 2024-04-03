
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractals_project/fractals/kochsFractal.dart';

class AnimatedKochsFractal extends StatefulWidget {
  const AnimatedKochsFractal({super.key});

  @override
  State<AnimatedKochsFractal> createState() => _AnimatedKochsFractalState();
}

class _AnimatedKochsFractalState extends State<AnimatedKochsFractal>  with TickerProviderStateMixin {

  late AnimationController controller;
  int step = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    final tween = IntTween(begin: 0, end: 13).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.bounceIn,

    ));

    tween.addListener(() {
      setState(() {
        step = tween.value;
      });
    });

    controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      width: 1000,
      height: 1000,
      child: Transform.rotate(
        angle: 0,
        child: CustomPaint(
          painter: TrianglePainter(step: step),
          size: Size(500, 500),
        ),
      ),

    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
