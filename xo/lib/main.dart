import 'package:flutter/material.dart';

void main() => runApp(TicTacToe());

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: TicTacToeBoard(),
      ),
    );
  }
}

class TicTacToeLogic {
  late List<List<String>> _gameBoard;
  late bool _isPlayer1Turn;
  late Function(String) showWinnerCallback;
  late final _currentPlayer = 'Player 1';

  String getCurrentPlayer() {
    return _currentPlayer;
  }

  List<List<String>> getGameBoard() {
    return _gameBoard;
  }

  void checkWinner() {
    _checkWinner();
  }

  TicTacToeLogic({required this.showWinnerCallback}) {
    _initializeGame();
  }

  void _initializeGame() {
    _gameBoard = List.generate(3, (_) => List.filled(3, ''));
    _isPlayer1Turn = true;
  }

  bool handleTap(int row, int col) {
    if (_gameBoard[row][col] == '') {
      _gameBoard[row][col] = _isPlayer1Turn ? 'X' : 'O';
      _isPlayer1Turn = !_isPlayer1Turn;
      return true;
    }
    return false;
  }

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (_gameBoard[i][0] != '' &&
          _gameBoard[i][0] == _gameBoard[i][1] &&
          _gameBoard[i][1] == _gameBoard[i][2]) {
        showWinnerCallback(_gameBoard[i][0]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_gameBoard[0][i] != '' &&
          _gameBoard[0][i] == _gameBoard[1][i] &&
          _gameBoard[1][i] == _gameBoard[2][i]) {
        showWinnerCallback(_gameBoard[0][i]);
        return;
      }
    }

    // Check diagonals
    if (_gameBoard[0][0] != '' &&
        _gameBoard[0][0] == _gameBoard[1][1] &&
        _gameBoard[1][1] == _gameBoard[2][2]) {
      showWinnerCallback(_gameBoard[0][0]);
      return;
    }
    if (_gameBoard[0][2] != '' &&
        _gameBoard[0][2] == _gameBoard[1][1] &&
        _gameBoard[1][1] == _gameBoard[2][0]) {
      showWinnerCallback(_gameBoard[0][2]);
      return;
    }

    // Check for a draw
    bool isBoardFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_gameBoard[i][j] == '') {
          isBoardFull = false;
          break;
        }
      }
    }
    if (isBoardFull) {
      showWinnerCallback('Draw');
    }
  }
}

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  late TicTacToeLogic logic;
  late String _currentPlayer;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textEditingControllerc = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPlayer = 'Player 1';
    logic = TicTacToeLogic(showWinnerCallback: (winner) {
      if (winner != null) {
        _showWinnerDialog(winner);
      }
    });
    logic._initializeGame();
  }

  void _handleTap(int row, int col) {
    setState(() {
      logic.handleTap(row, col);
      logic.checkWinner();
    });
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content:
              Text(winner == 'Draw' ? 'It\'s a draw!' : 'Winner is $winner!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                logic._initializeGame();
                setState(() {});
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentPlayer = logic.getCurrentPlayer();
    List<List<String>> _gameBoard = logic.getGameBoard();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Current Player: $_currentPlayer',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 20.0),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            int row = index ~/ 3;
            int col = index % 3;
            return GestureDetector(
              onTap: () => _handleTap(row, col),
              child: Container(
                color: Colors.blueGrey,
                child: Center(
                  child: Text(
                    _gameBoard[row][col],
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: 'Enter row ',
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: textEditingControllerc,
          decoration: InputDecoration(
            labelText: 'Enter column',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _handleTap(int.parse(textEditingController.text),
                int.parse(textEditingControllerc.text));
          },
          child: Text('submit'),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            setState(() {
              logic._initializeGame();
            });
          },
          child: Text('Restart Game'),
        ),
      ],
    );
  }
}

class TicTacToeBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return User();
  }
}