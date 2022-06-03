import 'package:flutter/material.dart';

class ThemeHelper {
  BoxDecoration informationBoxDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      color: Colors.blue[700],
    );
  }
}
