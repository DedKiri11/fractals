import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fractals/fractalJuliasSet.dart';

class AnimatedJuliaFractal extends StatefulWidget {
  const AnimatedJuliaFractal({super.key});

  @override
  State<AnimatedJuliaFractal> createState() => _AnimatedJuliaFractalState();
}

class _AnimatedJuliaFractalState extends State<AnimatedJuliaFractal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation curve;
  final _animationForRealPart = Tween<double>(
    begin: -0.8,
    end: -0.75,
  );

  final _animationForImaginaryPart = Tween<double>(
    begin: 0.11,
    end: 0.15,
  );
  double realPart = 0;
  double imaginaryPart = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    curve = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

     _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width /4,
      height: MediaQuery.of(context).size.width /4,
      // child: ClipOval(
      //    clipBehavior: Clip.hardEdge,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
                painter: JuliaSetPainter(
                    realPart: _animationForRealPart.evaluate(curve),
                    imaginaryPart: _animationForImaginaryPart.evaluate(curve),
                    iterations: 100,
                    color: Colors.red));
          }
        )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
