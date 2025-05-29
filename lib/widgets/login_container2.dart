import 'package:flutter/material.dart';

class LoginContainer2 extends StatelessWidget {
  const LoginContainer2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.37,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/image/imagen_login.jpg'),
          fit: BoxFit.cover,
        ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      ),
    );
  }
}
