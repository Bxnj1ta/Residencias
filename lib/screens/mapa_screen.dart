import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: Text(
          'Mapa',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'perfil');
            },
            icon:
                const Icon(Icons.account_circle, size: 30, color: Colors.black),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
              child: Text('Agregar Mapa',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))),
        ],
      ),
      bottomNavigationBar: const BotonAbajoScreen(),
    );
  }
}
