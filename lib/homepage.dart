import 'dart:async';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //bird variables
  static double birdY = 0; //Posicion del ave
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5; //how strong the jumo is

  bool gameHasStarted = false;

  void starGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {

      height = gravity * time * time + 30 * time;

      setState(() {
        birdY = initialPos - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }


      time += 0.1;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              'G A M E   O V E R',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                 'P L A Y   A G A I N',
                  style: TextStyle(color: Colors.brown),
                  ),
                ),
              )
            )
          ],
        );
      },
    );
  }

  void jump() {
    setState(() {
     time = 0;
     initialPos = birdY;
    });
  }

  bool birdIsDead() {
    //checks if the bird is hitting the top or bottom of the screen
      if (birdY < -1 || birdY > 1) {
        return true;
      }
      //checks if the bird is hitting a barrier
      return false;
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : starGame,
      child: Scaffold(
        body: Column(
          children:[
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(child: Stack(children:[
                  MyBird(
                    birdY: birdY,
                  ),
                  Container(
                    alignment: Alignment(0,-0.5),
                    child: Text(
                      gameHasStarted ? '' :'T A B  T O  P L A Y',
                    style: TextStyle(fontSize: 20, color: Colors.white),),
                  )
                ],
                ),
                ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.brown,
                ),
              )
          ]
        )
      ),
    );
  }
}