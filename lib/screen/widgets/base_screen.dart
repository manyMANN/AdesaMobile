import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  const BaseScreen({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.asset('assets/img/logoAAB.png', fit: BoxFit.contain),
        ),
        Positioned.fill(
          child: Container(color: const Color.fromRGBO(255, 255, 255, 0.9)),
        ),
        // Contenido centrado
        SafeArea(child: Center(child: child)),
      ],
    );
  }
}
