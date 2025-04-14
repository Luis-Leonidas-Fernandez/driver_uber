import 'package:flutter/material.dart';

class CarImage extends StatelessWidget {

  const CarImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/car_b.png',
      width: 120,
      height: 120,
      fit: BoxFit.contain,
    );
  }
}