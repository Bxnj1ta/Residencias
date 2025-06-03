import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final usuario = _correoController.text.trim();
                            final password = _passwordController.text.trim();

                            final agendaProvider = Provider.of<AgendaProvider>(context, listen: false);
                            agendaProvider.setCredenciales(usuario, password);

                            // Mostrar loading mientras se carga la agenda
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );

                            try {
                              await agendaProvider.cargarAgenda();
                              Navigator.pop(context); // Quitar loading
                              Navigator.pushReplacementNamed(context, 'home'); // Ir a la pantalla principal
                            } catch (e) {
                              Navigator.pop(context); // Quitar loading
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${agendaProvider.error ?? e.toString()}')),
                              );
                            }
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
