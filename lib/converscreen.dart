import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  final bool gameHasStarted;

  MyCoverScreen({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,  
      child: Center(
        child: Text(
          gameHasStarted ? '' : 'T A P  T O  P L A Y',
          style: TextStyle(
            fontSize: 30, 
            color: Colors.brown,
            fontWeight: FontWeight.bold,  
            letterSpacing: 5,  
          ),
          textAlign: TextAlign.center,  
        ),
      ),
    );
  }
}
