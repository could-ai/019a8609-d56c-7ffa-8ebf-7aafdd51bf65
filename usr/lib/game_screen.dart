import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  bool _gameStarted = false;
  Alignment _targetPosition = Alignment.center;
  final Random _random = Random();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _gameStarted = true;
      _moveTarget();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _stopGame();
      }
    });
  }

  void _stopGame() {
    _timer?.cancel();
    setState(() {
      _gameStarted = false;
    });
    _showGameOverDialog();
  }

  void _moveTarget() {
    setState(() {
      _targetPosition = Alignment(
        _random.nextDouble() * 2 - 1,
        _random.nextDouble() * 2 - 1,
      );
    });
  }

  void _onTargetTap() {
    if (_gameStarted) {
      setState(() {
        _score++;
      });
      _moveTarget();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: $_score'),
          actions: <Widget>[
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tap the Target!'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Score: $_score', style: const TextStyle(fontSize: 24)),
                    Text('Time: $_timeLeft', style: const TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              Expanded(
                child: _gameStarted
                    ? Align(
                        alignment: _targetPosition,
                        child: GestureDetector(
                          onTap: _onTargetTap,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: ElevatedButton(
                          onPressed: _startGame,
                          child: const Text('Start Game'),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
