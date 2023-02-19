import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'D15CRYPT0R',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }
}
