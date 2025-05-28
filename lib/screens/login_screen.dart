import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset(
                'assets/image/imagen_login.jpg',
                fit: BoxFit.cover, 
                cacheWidth: 600,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.85), // 85% opacidad
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Inicia Sesión',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.black87),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: 'Correo',
                        prefixIcon: Icons.account_circle,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Contraseña',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'home');
                          },
                          style: Theme.of(context).elevatedButtonTheme.style,
                          child: Text(
                            'Iniciar Sesión',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}