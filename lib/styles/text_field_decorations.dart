import 'package:flutter/material.dart';

class TextFieldStyles {

  static InputDecoration inputDecoration(double screenHeight, String tittle) {
    return InputDecoration(
      hintText: tittle,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: screenHeight <= 346 ? 10 : 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      border: InputBorder.none,
    );
  }

  static TextStyle textFieldTextStyle() {
    return const TextStyle(color: Colors.white);
  }
}
