import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fractals/fractalJuliasSet.dart';

class AnimatedJuliaFractal extends StatefulWidget {
  const AnimatedJuliaFractal({super.key, required this.customPaint});

  final JuliaSetWidget customPaint;

  @override
  State<AnimatedJuliaFractal> createState() => _AnimatedJuliaFractalState();
}

class _AnimatedJuliaFractalState extends State<AnimatedJuliaFractal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation curve;

  late Tween<double> _animationForRealPart;

  late Tween<double> _animationForImaginaryPart;
  double realPart = 0;
  double imaginaryPart = 0;

  @override
  void initState() {
    super.initState();

    _animationForRealPart = Tween<double>(
      begin: widget.customPaint.realPart,
      end: widget.customPaint.realPart + 0.2,
    );

    _animationForImaginaryPart = Tween<double>(
      begin: widget.customPaint.imaginaryPart,
      end: widget.customPaint.imaginaryPart - 0.2,
    );

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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: ClipOval(
          clipBehavior: Clip.hardEdge,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                    painter: JuliaSetPainter(
                        realPart: _animationForRealPart.evaluate(curve),
                        imaginaryPart:
                            _animationForImaginaryPart.evaluate(curve),
                        iterations: widget.customPaint.iterations,
                        color: widget.customPaint.color));
              })),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
