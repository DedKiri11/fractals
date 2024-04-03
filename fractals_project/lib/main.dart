import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fractals_project/fractals/kochsFractal.dart';

import 'screens/home.dart';


//
// void main() {
//   runApp(MaterialApp(home: FlutterPage()));
// }
//
// class FlutterPage extends StatelessWidget {
//   const FlutterPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: AnimatedSquare(),
//     ));
//   }
// }
//
// class SquarePainter extends CustomPainter {
//   final double x1;
//   final double x2;
//   final double y1;
//   final double y2;
//
//   SquarePainter(this.x1, this.x2, this.y1, this.y2);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     canvas.drawRect(Rect.fromLTWH(x1, x2, y1, y2), paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
//
//
// }
//
// class SquareWidget extends StatefulWidget {
//   @override
//   State<SquareWidget> createState() => _SquareWidgetState();
// }
//
// class _SquareWidgetState extends State<SquareWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: SquarePainter(20,50,5,5),
//     );
//   }
// }
//
// class AnimatedSquare extends StatefulWidget {
//   @override
//   _AnimatedSquareState createState() => _AnimatedSquareState();
// }
//
// class _AnimatedSquareState extends State<AnimatedSquare>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller =
//         AnimationController(duration: Duration(seconds: 2), vsync: this);
//
//     _animation = Tween<double>(begin: 0.0, end: 200.0).animate(_controller)
//       ..addListener(() {
//         setState(() {});
//       });
//
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: SquarePainter(50, 50,_animation.value, _animation.value),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
//
//

void main() {
  runApp(MaterialApp(
    home: HomePage()
  ));
}
