import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { FocusScope.of(context).requestFocus(FocusNode()); },
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Inicia Sesión', style: Theme.of(context).textTheme.headlineLarge,),
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
                  //const SizedBox(height: 5),
                  //Align(alignment:Alignment.centerRight,child:TextButton(onPressed:(){},child:Text('¿Olvidó su contraseña?',style:Theme.of(context).textTheme.labelSmall),),),//no puede ser una funcionalidad
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton( //BOTON LOGIN
                      onPressed: () {
                        Navigator.pushNamed(context, 'home');
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
    );
  }
}