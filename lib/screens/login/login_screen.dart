import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validarCorreo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(value)) {
      return 'Formato de correo no válido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Inicia Sesión', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 30),

                    CustomTextField(
                      hintText: 'Correo',
                      prefixIcon: Icons.account_circle,
                      keyboardType: TextInputType.emailAddress,
                      controller: _correoController,
                      validator: _validarCorreo,
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      hintText: 'Contraseña',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) => (value == null || value.isEmpty) ? 'Ingresa la contraseña' : null,
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, 'home');
                          }
                        },
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: Center(
                          child: Text('Iniciar Sesión', style: Theme.of(context).textTheme.labelMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
