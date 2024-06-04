import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawTriangle extends StatelessWidget {
  final int step;
  final double shrinkBy;

  const DrawTriangle({super.key, required this.step, required this.shrinkBy});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(step: step, shrinkBy: shrinkBy),
      size: Size(200, 200),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({
    required this.step,
    required this.shrinkBy,
  });
  final double shrinkBy;
  int step;

  @override
  void paint(Canvas canvas, Size size) {
    drawTriangle(canvas, size, Offset(size.width / 2, size.height / 2),
        size.width * 0.6, 0, 0.5, Colors.lightBlue, shrinkBy, 0, step);
  }

  void drawTriangle(
      Canvas canvas,
      Size size,
      Offset center,
      double sideLength,
      double degreesRotate,
      double thickness,
      Color color,
      double shrinkSideBy,
      int iteration,
      int maxDepth) {
    double triangleHeight = (sideLength * sqrt(3) / 2);

    Offset topSide = Offset(center.dx, center.dy - triangleHeight / 2);
    Offset leftSide =
        Offset(center.dx - sideLength / 2, center.dy + triangleHeight / 2);
    Offset rightSide =
        Offset(center.dx + sideLength / 2, center.dy + triangleHeight / 2);

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.square;

    if (degreesRotate != 0) {
      topSide = rotate(topSide, center, degreesRotate);
      leftSide = rotate(leftSide, center, degreesRotate);
      rightSide = rotate(rightSide, center, degreesRotate);
    }

    List<List<Offset>> lines = [
      [topSide, leftSide],
      [topSide, rightSide],
      [leftSide, rightSide],
    ];

    int lineNumber = 0;

    lines.forEach((line) {
      lineNumber += 1;
      canvas.drawLine(line[0], line[1], paint);

      if (iteration < maxDepth && (iteration < 1 || lineNumber < 3)) {
        double gradient = (line[1].dy - line[0].dy) / (line[1].dx - line[0].dx);
        double newSideLength = sideLength * shrinkSideBy;

        Offset centerOfLine = Offset(
            (line[0].dx + line[1].dx) / 2, (line[0].dy + line[1].dy) / 2);

        Offset newCenter = Offset(0, 0);

        double newRotation = degreesRotate;

        if (lineNumber == 1) {
          newRotation += 60;
        } else if (lineNumber == 2) {
          newRotation -= 60;
        } else {
          newRotation += 180;
        }

        if (gradient < 0.0001 && gradient > -0.0001) {
          newCenter = centerOfLine.dy - center.dy > 0
              ? Offset(centerOfLine.dx,
                  centerOfLine.dy + triangleHeight * (shrinkSideBy / 2))
              : Offset(centerOfLine.dx,
                  centerOfLine.dy - triangleHeight * (shrinkSideBy / 2));
        } else if (gradient != 0) {
          double differenceFromCenter = -1 / gradient;
          double distanceFromCenter = triangleHeight * (shrinkSideBy / 2);
          double xLength = sqrt((pow(distanceFromCenter, 2)) /
              (1 + pow(differenceFromCenter, 2)));
          if (centerOfLine.dx < center.dx && xLength > 0) {
            xLength *= -1;
          }

          double yLength = xLength * differenceFromCenter;

          newCenter =
              Offset(centerOfLine.dx + xLength, centerOfLine.dy + yLength);
        }
        drawTriangle(canvas, size, newCenter, newSideLength, newRotation,
            thickness, color, shrinkSideBy, iteration + 1, maxDepth);
      }
    });
  }

  double degreesToRadians(double degrees) {
    return degrees * (3.141592653589793238462643383279502884 / 180.0);
  }

  Offset rotate(Offset coordinate, Offset center, double degrees) {
    var x = coordinate.dy - center.dy;
    var y = coordinate.dx - center.dx;

    double radians = degreesToRadians(degrees);

    var newX = (x * cos(radians)) - (y * sin(radians));
    var newY = (y * cos(radians)) + (x * sin(radians));

    return Offset(newY + center.dx, newX + center.dy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
