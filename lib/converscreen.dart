import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  final bool gameHasStarted;

  MyCoverScreen({required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          gameHasStarted ? 'G A M E  O V E R' : 'T A B  T O  P L A Y',
          style: TextStyle(fontSize: 20, color: Colors.brown),
        ),
      ),
    );
  }
}