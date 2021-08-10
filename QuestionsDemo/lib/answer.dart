import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function selectHandle;
  final String answerText;
  Answer(this.selectHandle, this.answerText);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
          onPressed: () {
            selectHandle();
          },
          child: Text(answerText),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.yellow))),
    );
  }
}
