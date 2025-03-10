import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;

  MyBird({this.birdY, required this.birdWidth, required this.birdHeight});


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'lib/images/bird.png',
        width: MediaQuery.of(context).size.width * birdWidth / 2,
      ));
  }
}