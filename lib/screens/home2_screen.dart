import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localTheme = ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
    return Theme(
      data: localTheme,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 151, 121, 191),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Inicio Sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Correo',
                      prefixIcon:
                          Icon(Icons.account_circle, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                        },
                        child: const Text(
                          '¿Olvidó su contraseña?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'lista');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: const Color.fromARGB(255, 151, 121, 191),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
