import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractals_project/fractals/fractalJuliasSet.dart';

import '../widgets/textFields/textFieldForJuliaSet.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double imaginaryValue = 0.71;
  double realValue = -0.085;

  void _setText(String imaginary, String real) {
    setState(() {
      imaginaryValue = double.tryParse(imaginary) ?? imaginaryValue;
      realValue = double.tryParse(real) ?? realValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fractals painter"),
          actions: [
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () => null,
            ),
          ],
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                JuliaSetWidget(imaginaryValue, realValue),
                TextFieldForJuliaSet(onTextChanged: _setText)
              ],
            )));
  }
}
