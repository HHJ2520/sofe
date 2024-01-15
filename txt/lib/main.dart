import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ""));
  String currentPlayer = "X";
  int a = 0;

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
            // Display Tic Tac Toe Board
            Column(
              children: List.generate(
                3,
                (row) => Row(
                  children: List.generate(
                    3,
                    (col) => GestureDetector(
                      onTap: () {saveGame();
                        if (board[row][col] == "") {
                          setState(() {
                            board[row][col] = currentPlayer;
                            currentPlayer = (currentPlayer == "X") ? "O" : "X";

                            if (checkWinner()) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Winner!'),
                                    content: Text('$currentPlayer wins!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          resetGame();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          });
                        }a++;
                      },
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
            ),
            SizedBox(height: 20),
            // Save and Load Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await loadGamea();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Game Saved!"),
                    ));
                  },
                  child: Text("Save Game"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await loadGame();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Game Loaded!"),
                    ));
                  },
                  child: Text("Load Game"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> saveGame() async {
    final path = await _localPath;
    final file = File('$path/tic_tac_toe$a.txt');

    try {
      String gameData = jsonEncode({
        "board": board,
        "currentPlayer": currentPlayer,
      });
      await file.writeAsString(gameData);
    } catch (e) {
      print('Error saving game: $e');
    }
    a++;
  }

  Future<void> loadGame() async {
    a--;
    final path = await _localPath;
    final file = File('$path/tic_tac_toe$a.txt');

    try {
      String gameData = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(gameData);

      setState(() {
        board = List<List<String>>.from(data["board"].map((row) => List<String>.from(row)));
        currentPlayer = data["currentPlayer"];
      });
    } catch (e) {
      print('Error loading game: $e');
    }
  }
  Future<void> loadGamea() async {
    a++;
    final path = await _localPath;
    final file = File('$path/tic_tac_toe$a.txt');

    try {
      String gameData = await file.readAsString();
      Map<String, dynamic> data = jsonDecode(gameData);

      setState(() {
        board = List<List<String>>.from(data["board"].map((row) => List<String>.from(row)));
        currentPlayer = data["currentPlayer"];
      });
    } catch (e) {
      print('Error loading game: $e');
    }

  }

  bool checkWinner() {
    // Check rows
    for (int row = 0; row < 3; row++) {
      if (board[row][0] != "" && board[row][0] == board[row][1] && board[row][1] == board[row][2]) {
        return true;
      }
    }

    // Check columns
    for (int col = 0; col < 3; col++) {
      if (board[0][col] != "" && board[0][col] == board[1][col] && board[1][col] == board[2][col]) {
        return true;
      }
    }

    // Check diagonals
    if (board[0][0] != "" && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
      return true;
    }

    if (board[0][2] != "" && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
      return true;
    }

    return false;
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ""));
      currentPlayer = "X";
    });
  }
}
