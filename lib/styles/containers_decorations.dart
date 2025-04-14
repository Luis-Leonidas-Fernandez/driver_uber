import 'package:flutter/material.dart';

class ContainerStyles {

  
  static BoxDecoration containerDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(255, 251, 250, 252).withValues(),
        width: 1.4,
      ),
      color: const Color.fromARGB(255, 2, 2, 2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  static BoxDecoration containerIconDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: LinearGradient(
        colors: [
          const Color.fromARGB(188, 126, 124, 250).withValues(),
          const Color.fromARGB(188, 126, 124, 250),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}