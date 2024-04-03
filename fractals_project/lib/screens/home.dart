import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractals_project/fractals/kochsFractal.dart';

import '../animations/animatedKochsFractal.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ZoomableObject()),
    );
  }
}

class ZoomableObject extends StatefulWidget {
  const ZoomableObject({super.key});

  @override
  State<ZoomableObject> createState() => _ZoomableObjectState();
}

class _ZoomableObjectState extends State<ZoomableObject> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            scale = details.scale;
          });
        },
        child: Center(
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 1000.0,
              height: 1000.0,
              color: Colors.blue,
              child: Center(
                child: AnimatedKochsFractal()
              ),
            ),
          ),
        ),
      ),
    );
  }
}