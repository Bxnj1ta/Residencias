import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _recuerdame = false;

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

  Future<List<dynamic>> _cargarUsuariosMock() async {
    final String data = await rootBundle.loadString('lib/api/mocks/usuarios_mock.json');
    return json.decode(data);
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

                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Recuérdame'),
                          Checkbox(
                            value: _recuerdame,
                            onChanged: (value) {
                              setState(() {
                                _recuerdame = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final usuarios = await _cargarUsuariosMock();
                            final correo = _correoController.text;
                            final contrasena = _passwordController.text;
                            final usuario = usuarios.firstWhere(
                              (u) => u['correo'] == correo && u['contrasena'] == contrasena,
                              orElse: () => null,
                            );
                            if (!context.mounted) return;
                            if (usuario == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Correo o contraseña incorrectos')),
                              );
                              return;
                            }
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('correo', usuario['correo']);
                            await prefs.setString('nombre', usuario['nombre']);
                            if (_recuerdame) {
                              await prefs.setBool('isLoggedIn', true);
                            } else {
                              await prefs.remove('isLoggedIn');
                            }
                            if (!context.mounted) return;
                            Navigator.pushReplacementNamed(context, 'home');
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
