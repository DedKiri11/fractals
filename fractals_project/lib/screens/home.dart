import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractals_project/animations/animatedKochsFractal.dart';
import 'package:fractals_project/fractals/fractalJuliasSet.dart';
import '../animations/animatedJuliasFractal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                JuliaSetWidget(),

              ],
            ))
    );
  }
}



