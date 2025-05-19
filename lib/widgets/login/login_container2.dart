import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class LoginContainer2 extends StatelessWidget {
  const LoginContainer2({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: sizeScreen.height * 0.4,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 151, 121, 191),
        Color.fromARGB(255, 50, 32, 73),
      ])),
      child: const Stack(
        children: [
          Positioned(top: 30, left: 130, child: Icon(Icons.person_pin_rounded, color: Colors.white, size: 100)),
          Positioned(top: 90, left: 30, child: Buble()),
          Positioned(top: -40, left: -30, child: Buble()),
          Positioned(top: -50, left: -20, child: Buble()),
          Positioned(top: 120, right: 20, child: Buble()),
          Positioned(top: 20, right: 80, child: Buble()),
          Positioned(top: -50, right: -20, child: Buble()),
        ],
      ),
    );
  }
}
