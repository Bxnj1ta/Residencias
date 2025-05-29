import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(  //colocar fit: StackFit.expand, si se quiere la imagen de fondo completa
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)], //Estos colores son los morados[Color.fromARGB(255, 50, 32, 73), Color.fromARGB(255, 151, 121, 191)]
                  begin: Alignment.topCenter,        
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            LoginContainer2(),
            LoginContainer1(),
          ],
        ),
      ),
    );
  }
}