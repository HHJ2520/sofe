import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameBoard extends StatelessWidget {
  final List<List<String>> board;
  final Function(int, int) onCellTap;

  GameBoard({required this.board, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (row) => Row(
          children: List.generate(
            3,
            (col) => GestureDetector(
              onTap: () => onCellTap(row, col),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    board[row][col],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, " "));
  String currentPlayer = "X";

  @override
  void initState() {
    super.initState();
    loadGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameBoard(
              board: board,
              onCellTap: (row, col) {
                if (board[row][col] == " ") {
                  setState(() {
                    board[row][col] = currentPlayer;
                    currentPlayer = (currentPlayer == "X") ? "O" : "X";
                  });
                  checkWinner();
                  saveGame();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetBoard();
              },
              child: Text("Reset Game"),
            ),ElevatedButton(
              onPressed: () {
                loadGame();
              },
              child: Text("loadGame"),
            ),
          ],
        ),
      ),
    );
  }

  void checkWinner() {
    // Check rows and columns
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != " ") {
        showWinnerDialog(board[i][0]);
        return;
      }
      if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != " ") {
        showWinnerDialog(board[0][i]);
        return;
      }
    }

    // Check diagonals
    if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != " ") {
      showWinnerDialog(board[0][0]);
      return;
    }
    if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != " ") {
      showWinnerDialog(board[0][2]);
      return;
    }

    // Check for a tie
    if (!board.any((row) => row.contains(" "))) {
      showWinnerDialog("Tie");
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(winner == "Tie" ? "It's a Tie!" : "Player $winner wins!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetBoard();
              },
              child: Text("Play Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    ); // Save the game when it's over
  }

  void resetBoard() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, " "));
      currentPlayer = "X";
    });
  }

  void saveGame() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("board", board.expand((row) => row).toList());
    prefs.setString("currentPlayer", currentPlayer);
  }

  void loadGame() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String>? savedBoard = prefs.getStringList("board");
      if (savedBoard != null) {
        board = List.generate(
          3,
          (row) => List.generate(
            3,
            (col) => savedBoard[row * 3 + col],
          ),
        );
      }

      currentPlayer = prefs.getString("currentPlayer") ?? "X";
    });
  }
}
