import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final residencias = [
      {'distancia': '1.2 km', 'direccion': 'Calle Primavera 123'},
      {'distancia': '2.5 km', 'direccion': 'Avenida Libertad 456'},
      {'distancia': '3.1 km', 'direccion': 'Boulevard Central 789'},
      {'distancia': '0.8 km', 'direccion': 'Callejón Los Pinos 321'},
      {'distancia': '1.7 km', 'direccion': 'Pasaje Las Flores 654'},
      {'distancia': '4.2 km', 'direccion': 'Camino Real 987'},
      {'distancia': '4.2 km', 'direccion': 'Camino Real 987'},
      {'distancia': '4.2 km', 'direccion': 'Camino Real 987'},
      {'distancia': '4.2 km', 'direccion': 'Camino Real 987'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: Text(
          'Residencias del Día',
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
          Expanded(
            child: ListView.builder(
              itemCount: residencias.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(255, 151, 121, 191),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: const Icon(Icons.adjust,
                        //Color amarillo para estados "en proceso", rojo para estados "pendiente"
                        size: 34,
                        color: Colors.yellow),
                    title: Text(residencias[index]['distancia']!),
                    subtitle: Text(residencias[index]['direccion']!),
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      Navigator.pushNamed(context, 'detalle');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BotonAbajoScreen(),
    );
  }
}
