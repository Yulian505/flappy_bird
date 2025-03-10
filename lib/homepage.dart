import 'dart:async';
import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/converscreen.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //bird variables
  static double birdY = 0; 
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; //how strong the gravity is
  double velocity = 3.5; //how strong the jump is
  double birdWeight = 0.1; //out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; //out of 2, 2 being the entire height of the screen

  //game settings
  bool gameHasStarted = false;

  //barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierHeight = 0.5; //out of 2
  List<List<double>> barrierWeight = [
    // out of 2, where 2 is the entire heigth of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6]
  ];


  void starGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //a real physical jump is the same as an upside down parabola
      //so this os a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      //check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }

      //keep the time going
      time += 0.1;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
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
              'G A M E  O V E R',
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

  bool birdIsDead() {
    //check if bird is hitting the top of the bottom of the screen
      if (birdY < -1 || birdY >1) {
        return true;
      }

      //hits barriesrs
      //check if bird is within x coordinates and y coordinates of the barriers

      for (int i = 0; i < barrierX.length; i++) {
        if (barrierX[i] <= birdWeight && 
            barrierX[i] + barrierWeight[i][0] >= -birdWeight &&
            (birdY <= -1 + barrierWeight[i][0] ||
               birdY + birdHeight >= 1 - barrierWeight[i][1])) { 
          return true;
        }
      }

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
                child: Center(
                  child: Stack(
                    children:[
                      //Bird
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWeight,
                        birdHeight: birdHeight,
                      ),

                      //tap to play
                      MyCoverScreen(gameHasStarted: gameHasStarted),

                      //top barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[0][0],
                        isThisBottomBarrier: false,
                      ),

                      //bottom barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[0][1],
                        isThisBottomBarrier: true,
                      ),

                      //top barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[1][0],
                        isThisBottomBarrier: false,
                      ),

                      //bottom barrier 1

                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[1][1],
                        isThisBottomBarrier: true,
                      ),

                      Container(
                        alignment: Alignment(0,-0.5),
                        child: Text(
                        gameHasStarted ? '' :'T A B  T O  P L A Y',
                        style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),
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