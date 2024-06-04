import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fractals_project/animations/animatedJuliasFractal.dart';
import 'package:fractals_project/fractals/fractalJuliasSet.dart';
import 'package:fractals_project/widgets/colorPicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../widgets/textFields/textFieldForJuliaSet.dart';

class JuliaScreen extends StatefulWidget {
  JuliaScreen({super.key});

  @override
  State<JuliaScreen> createState() => _JuliaScreenState();
}

class _JuliaScreenState extends State<JuliaScreen> {
  double imaginaryValue = 0.156;
  double realValue = -0.8;
  int iterationsValue = 100;
  Color color = Colors.red;
  bool isLoading = false;
  bool isAnimating = false;
  bool isAnimatingText = false;
  String animatedButtonText = "";

  Future<void> _saveImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    CustomPainter customPainter = JuliaSetPainter(
        realPart: realValue,
        imaginaryPart: imaginaryValue,
        color: color,
        iterations: iterationsValue);

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
      setState(() {
        isLoading = false;
      });
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
                  setState(() {
                    isLoading = true;
                  });
                }),
            CustomColorPicker(onColorChanged: _setColor),
          ],
        ),
        body: isLoading
            ? Center(child: const CircularProgressIndicator())
            : ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/2 ,
                              height: MediaQuery.of(context).size.width/2 ,
                              child: isAnimating
                                  ? AnimatedJuliaFractal(
                                      customPaint: JuliaSetWidget(realValue,
                                          imaginaryValue, iterationsValue,
                                          color: color))
                                  : JuliaSetWidget(realValue, imaginaryValue,
                                      iterationsValue,
                                      color: color),
                            ),
                            Column(
                              children: [
                                Text("Real value"),
                                Slider(
                                  value: realValue,
                                  max: 0.9,
                                  min: -0.9,
                                  divisions: 100,
                                  label: realValue.toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      realValue = value;
                                    });
                                  },
                                ),
                                Text("Imaginary value"),
                                Slider(
                                  value: imaginaryValue,
                                  max: 0.9,
                                  min: -0.9,
                                  divisions: 100,
                                  label: imaginaryValue.toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      imaginaryValue = value;
                                    });
                                  },
                                ),
                                Text("Iterations value"),
                                Slider(
                                  value: iterationsValue.toDouble(),
                                  max: 200,
                                  min: 50,
                                  divisions: 5,
                                  label: iterationsValue.toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      iterationsValue = value.toInt();
                                    });
                                  },
                                ),
                                FilledButton(
                                    onPressed: () {
                                      setState(() {
                                        isAnimating =
                                            isAnimating ? false : true;
                                      });
                                    },
                                    child: Text(isAnimating
                                        ? "Disable animation "
                                        : "Animate"))
                              ],
                            ),
                          ],
                        )),
                  ]));
  }
}
