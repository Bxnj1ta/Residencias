import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Mapa'),
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
      //bottomNavigationBar: const BotonAbajoScreen(),
    );
  }
}
