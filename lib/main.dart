import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tic Tac Toe',
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<String> _gameBoard = List.generate(9, (index) => '');

  bool _isPlayer1 = true;
  bool _gameOver = false;
  String? _winner;

  void _makeMove(int index) {
    if (_gameBoard[index] != '' || _gameOver) {
      return;
    }

    setState(() {
      _gameBoard[index] = _isPlayer1 ? 'X' : 'O';
      _isPlayer1 = !_isPlayer1;
      _checkForWinner();
    });
  }

  void _checkForWinner() {
    final List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final combination in winningCombinations) {
      final a = combination[0];
      final b = combination[1];
      final c = combination[2];

      if (_gameBoard[a] != '' &&
          _gameBoard[a] == _gameBoard[b] &&
          _gameBoard[b] == _gameBoard[c]) {
        setState(() {
          _gameOver = true;
          _winner = _gameBoard[a];
        });
        break;
      }
    }

    if (!_gameBoard.contains('') && _winner == null) {
      setState(() {
        _gameOver = true;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _gameBoard.fillRange(0, 9, '');
      _isPlayer1 = true;
      _gameOver = false;
      _winner = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Tic Tac Toe'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _makeMove(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text(
                        _gameBoard[index],
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            if (_gameOver)
              Text(
                _winner != null ? 'Player $_winner has won!' : 'It\'s a tie!',
                style: const TextStyle(fontSize: 24),
              ),
            if (_gameOver)
              MaterialButton(
                color: Colors.amber,
                child: Text('Play Again'),
                onPressed: _resetGame,
              ),
          ],
        ),
      ),
    );
  }
}
