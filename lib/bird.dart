import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight;

  MyBird({
    required this.birdY, 
    required this.birdWidth, 
    required this.birdHeight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'lib/images/bird.jpg', 
        width: MediaQuery.of(context).size.width * birdWidth, 
        height: MediaQuery.of(context).size.height * birdHeight, 
        fit: BoxFit.fill, // Cambia a BoxFit.fill para asegurarte de que la imagen ocupe todo el espacio
      ),
    );
  }
}