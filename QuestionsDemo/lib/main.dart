import 'package:flutter/material.dart';
import 'result.dart';
import 'quiz.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;

  final _questions = const [
    {
      'questionText': 'What\'s your favorite color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 9},
        {'text': 'Green', 'score': 8},
        {'text': 'White', 'score': 7}
      ],
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'Cat', 'score': 10},
        {'text': 'Elephant', 'score': 9},
        {'text': 'Lion', 'score': 8},
        {'text': 'Monkey', 'score': 7},
        {'text': 'Bull', 'score': 9}
      ],
    },
    {
      'questionText': 'Who\'s your favorite instructor?',
      'answers': [
        {'text': 'John', 'score': 10},
        {'text': 'Mike', 'score': 9},
        {'text': 'Lisa', 'score': 8},
        {'text': 'Bob', 'score': 7}
      ],
    },
  ];
  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
  }

  void _resetQuiz() => setState(() {
        _questionIndex = 0;
        _totalScore = 0;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Question Demo"),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(_questionIndex, _questions, _answerQuestion)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
