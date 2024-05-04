import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JuliaSetWidget extends StatefulWidget {
  final double realPart;
  final double imaginaryPart;

  JuliaSetWidget(this.realPart, this.imaginaryPart, {super.key});

  @override
  State<JuliaSetWidget> createState() => _JuliaSetWidgetState();
}

class _JuliaSetWidgetState extends State<JuliaSetWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      //(realPart: 0.285, imaginaryPart: 0.01) (realPart: -0.085, imaginaryPart: 0.71) (realPart: -0.74543, imaginaryPart: 0.11031)
      //painter: JuliaSetPainter(realPart: -0.8, imaginaryPart: 0.156),
      //painter: JuliaSetPainter(realPart: 0.285, imaginaryPart: 0.01),
      painter: JuliaSetPainter(
          realPart: widget.realPart, imaginaryPart: widget.imaginaryPart),
      // painter: JuliaSetPainter(realPart: -0.74543, imaginaryPart: 0.11031),
    );
  }
}

class JuliaSetPainter extends CustomPainter {
  final double realPart;
  final double imaginaryPart;

  JuliaSetPainter({required this.realPart, required this.imaginaryPart});

  @override
  void paint(Canvas canvas, Size size) {
    ComplexNumber c = ComplexNumber(realPart, imaginaryPart);
    XBitmap bmp = plotJuliaSet(c, size.width.toInt(), size.height.toInt(), 100);

    for (int i = 0; i < bmp.pixels.length; i++) {
      for (int j = 0; j < bmp.pixels[i].length; j++) {
        Color color = bmp.pixels[i][j];
        Paint paint = Paint()..color = color;
        canvas.drawRect(
            Rect.fromPoints(Offset(i.toDouble(), j.toDouble()),
                Offset((i + 1).toDouble(), (j + 1).toDouble())),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ComplexNumber {
  double real, imaginary;

  ComplexNumber(this.real, this.imaginary);

  double get mod => sqrt(real * real + imaginary * imaginary);

  ComplexNumber operator *(ComplexNumber other) {
    double realPart = real * other.real - imaginary * other.imaginary;
    double imagPart = real * other.imaginary + imaginary * other.real;
    return ComplexNumber(realPart, imagPart);
  }

  ComplexNumber operator +(ComplexNumber other) {
    double realPart = real + other.real;
    double imagPart = imaginary + other.imaginary;
    return ComplexNumber(realPart, imagPart);
  }
}

class XBitmap {
  List<List<Color>> pixels = [];

  XBitmap(int w, int h) {
    pixels = List.generate(w, (i) => List.generate(h, (j) => Color(0)));
  }

  void setPixel(int x, int y, Color color) {
    pixels[x][y] = color;
  }
}

XBitmap plotJuliaSet(ComplexNumber c, int w, int h, int maxIter,
    {double xMin = double.nan,
    double yMin = double.nan,
    double xMax = double.nan,
    double yMax = double.nan}) {
  double r = calculateR(c);
  if (xMin.isNaN || xMax.isNaN || yMin.isNaN) {
    xMin = -r;
    yMin = -r;
    xMax = r;
    yMax = r;
  }

  double xStep = (xMax - xMin).abs() / w;
  double yStep = (yMax - yMin).abs() / h;
  XBitmap bmp = XBitmap(w, h);

  Map<int, Map<int, int>> xyIdx = {};
  int maxIdx = 0;

  for (int i = 0; i < w; i++) {
    xyIdx[i] = {};
    for (int j = 0; j < h; j++) {
      double x = xMin + i * xStep;
      double y = yMin + j * yStep;
      ComplexNumber z = ComplexNumber(x, y);
      List<ComplexNumber> zIter = sqPolyIteration(z, c, maxIter, r);
      int idx = zIter.length - 1;
      if (maxIdx < idx) {
        maxIdx = idx;
      }
      xyIdx[i]?[j] = idx;
    }
  }

  for (int i = 0; i < w; i++) {
    for (int j = 0; j < h; j++) {
      int? idx = xyIdx[i]?[j];
      double x = xMin + i * xStep;
      double y = yMin + j * yStep;
      ComplexNumber z = ComplexNumber(x, y);
      bmp.setPixel(w - i - 1, j,
          complexHeatMap(idx!.toDouble(), 0, maxIdx.toDouble(), z * z, r));
    }
  }

  return bmp;
}

List<ComplexNumber> sqPolyIteration(
    ComplexNumber z0, ComplexNumber c, int n, double r) {
  List<ComplexNumber> res = [z0];
  for (int i = 0; i < n; i++) {
    if (r > 0) {
      if (res.last.mod > r) {
        break;
      }
    }
    res.add(res.last * res.last + c);
  }
  return res;
}

double calculateR(ComplexNumber c) {
  return (1 + sqrt(1 + 4 * c.mod)) / 2;
}

Color complexHeatMap(
    double value, double min, double max, ComplexNumber z, double r) {
  double val = (value - min) / (max - min);
  int red = (255 * val).round();
  int green = (2 * (1 - val)).round();
  int blue = (213 * (z.mod / r > 1 ? 1 : z.mod / r)).round();
  return Color.fromRGBO(red, green, blue, 1);
}
