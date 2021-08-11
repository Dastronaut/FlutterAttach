import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetQuiz;

  Result(this.totalScore, this.resetQuiz);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Your score: " + totalScore.toString(),
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
            onPressed: () {
              resetQuiz();
            },
            child: Text("Restart Quiz")),
      ],
    ));
  }
}
