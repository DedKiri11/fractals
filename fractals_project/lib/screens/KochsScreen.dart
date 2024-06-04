import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fractals_project/animations/animatedJuliasFractal.dart';
import 'package:fractals_project/fractals/fractalJuliasSet.dart';
import 'package:fractals_project/fractals/kochsFractal.dart';
import 'package:fractals_project/widgets/colorPicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../widgets/textFields/textFieldForJuliaSet.dart';

class KochsScreen extends StatefulWidget {
  KochsScreen({super.key});

  @override
  State<KochsScreen> createState() => _KochsScreenState();
}

class _KochsScreenState extends State<KochsScreen> {
  double shrinkBy = 0.5;
  double step = 5;
  Color color = Colors.red;
  bool isLoading = false;

  Future<void> _saveImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    CustomPainter customPainter = TrianglePainter(
        step: step.toInt(),
        shrinkBy: shrinkBy,);

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
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width - 200,
                              child: DrawTriangle(step: step.toInt(), shrinkBy: shrinkBy,),
                            ),
                            SizedBox(height: 100,),
                            Text("Step"),
                            Slider(
                              value: step,
                              max: 10,
                              min: 0,
                              divisions: 5,
                              label: step.toString(),
                              onChanged: (double value) {
                                setState(() {
                                  step = value;
                                });
                              },
                            ),
                            Text("Shrink By"),
                            Slider(
                              value: shrinkBy,
                              max: 1,
                              min: 0,
                              divisions: 10,
                              label: shrinkBy.toString(),
                              onChanged: (double value) {
                                setState(() {
                                  shrinkBy = value;
                                });
                              },
                            ),
                            FilledButton(onPressed: (){}, child: Text("Animate"))
                          ],
                        )),
                  ]));
  }
}
