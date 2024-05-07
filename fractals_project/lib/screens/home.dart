import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fractals_project/animations/animatedJuliasFractal.dart';
import 'package:fractals_project/fractals/fractalJuliasSet.dart';
import 'package:fractals_project/widgets/colorPicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../widgets/textFields/textFieldForJuliaSet.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double imaginaryValue = 0.156;
  double realValue = -0.8;
  int iterationsValue = 100;
  Color color = Colors.red;

  Future<void> _saveImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    CustomPainter customPainter = JuliaSetPainter(
        realPart: realValue,
        imaginaryPart: imaginaryValue,
        color: color,
        iterations: iterationsValue);

    // Размеры вашего изображения
    final size = Size(1080, 1080);

    customPainter.paint(canvas, size);
    ui.Picture picture = recorder.endRecording();
    picture
        .toImage(size.width.toInt(), size.height.toInt())
        .then((image) async {
      ui.Image uiImage = image;
      ByteData? byteData =
          await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final result =
            await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
      }
    });
  }

  void _setColor(Color changedColor) {
    setState(() {
      color = changedColor;
    });
  }

  void _setText(String imaginary, String real, String iterations) {
    setState(() {
      iterationsValue = int.tryParse(iterations) ?? iterationsValue;
      imaginaryValue = double.tryParse(imaginary) ?? imaginaryValue;
      realValue = double.tryParse(real) ?? realValue;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Fractals painter"),
          actions: [
            IconButton(
                icon: Icon(Icons.save_alt),
                onPressed: () {
                  _saveImage();
                }),
            CustomColorPicker(onColorChanged: _setColor),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children:[
            Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                       width: MediaQuery.of(context).size.width,
                       height: MediaQuery.of(context).size.width-100,
                      child: JuliaSetWidget(realValue, imaginaryValue, iterationsValue,
                          color: color),
                    ),
                    TextFieldForJuliaSet(onTextChanged: _setText),
                   
                  ],
                )),
          ]
        ));
  }
}
