import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  final String label;
  final Color bgcolor;
  final Color forcecolor;
  // ignore: prefer_typing_uninitialized_variables
  final onTap;

  const Mybutton({
    Key? key,
    required this.label,
    required this.bgcolor,
    required this.forcecolor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(bgcolor),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(fontSize: 24, color: forcecolor),
        ),
      ),
    );
  }
}
