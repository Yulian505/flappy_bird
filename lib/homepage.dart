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
  // Variables del ave
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -0.05; // Gravedad 
  double velocity = 0.1; // Velocidad de salto 
  double birdWeight = 0.1;
  double birdHeight = 0.1;

  // Variables del juego
  bool gameHasStarted = false;
  int score = 0; // Puntaje actual
  int highScore = 0; // Mejor puntaje

  // Variables de las barreras
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierHeight = 0.5; // Altura de las barreras
  List<List<double>> barrierWeight = [
    [0.4, 0.4],
    [0.4, 0.4]
  ];

  // Velocidad de las barreras y fondo
  double barrierSpeed = 0.02; 
  double backgroundSpeed = 0.01; 

  // Variable para controlar el movimiento del fondo
  double backgroundOffset = 0;

  // Reiniciar el juego
  void resetGame() {
    setState(() {
      birdY = 0;
      initialPos = birdY;
      time = 0;
      gameHasStarted = false;
      score = 0; // Reiniciar el puntaje
      barrierX = [2, 2 + 1.5]; // Restablecer la posición de las barreras
      backgroundOffset = 0; // Restablecer la posición del fondo
    });
  }

  // Inicia el juego
  void starGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // Movimiento del ave (caída por gravedad)
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      // Mover las barreras
      for (int i = 0; i < barrierX.length; i++) {
        barrierX[i] -= barrierSpeed;
      }

      // Mover el fondo
      backgroundOffset -= backgroundSpeed;

      // Si el fondo se ha desplazado completamente, se reinicia
      if (backgroundOffset <= -1) {
        backgroundOffset = 0;
      }

      // Si las barreras se salen de la pantalla, se reinicia
      for (int i = 0; i < barrierX.length; i++) {
        if (barrierX[i] < -1) {
          barrierX[i] = 2;
          score++; // Sumar un punto cuando el ave pasa una barrera
        }
      }

      // Verifica si el ave está muerto
      if (birdIsDead()) {
        // Actualizar el mejor puntaje
        if (score > highScore) {
          highScore = score;
        }
        timer.cancel();
        _showDialog();  
      }

      // Mantener el tiempo en marcha
      time += 0.1;
    });
  }

  // Método para hacer que el ave pueda saltar
  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  // Verifica si el pájaro está muerto
  bool birdIsDead() {
    // Solo verificar si el ave está muerto después de que ha comenzado el juego
    if (!gameHasStarted) return false;

    if (birdY < -1 || birdY > 1) {
      return true;
    }

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

  // Método que muestra el diálogo cuando el juego termina
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
          content: Text(
            'Score: $score\nBest score: $highScore',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                resetGame();  // Reiniciar el juego cuando el usuario toque "Play Again"
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
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
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : starGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue, // Fondo azul
                child: Center(
                  child: Stack(
                    children: [
                      // Fondo en movimiento
                      Positioned(
                        left: backgroundOffset * MediaQuery.of(context).size.width,
                        child: Container(
                          color: Colors.blue,
                          width: MediaQuery.of(context).size.width * 2, // Doble del ancho de la pantalla
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),

                      // Movimiento del ave
                      MyBird(
                        birdY: birdY,
                        birdWidth: birdWeight,
                        birdHeight: birdHeight,
                      ),
                      
                      // Barreras
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[0][1],
                        isThisBottomBarrier: true,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[1][0],
                        isThisBottomBarrier: false,
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierHeight: barrierHeight,
                        barrierWidth: barrierWeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                      
                      // Pantalla de inicio o fin del juego
                      MyCoverScreen(gameHasStarted: gameHasStarted),
                    ],
                  ),
                ),
              ),
            ),
            // Mostrar puntaje en la parte inferior
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Center(
                  child: Text(
                    'Score: $score\nHigh Score: $highScore',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}