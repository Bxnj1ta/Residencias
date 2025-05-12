import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final residencias = [
      {'estado': 'Hecho', 'fecha_ingreso/salida': '12:00:00/16:00:00'},
      {'estado': 'Hecho', 'fecha_ingreso/salida': '12:00:00/15:00:00'},
      {'estado': 'Hecho', 'fecha_ingreso/salida': '12:00:00/17:00:00'},
      {'estado': 'Hecho', 'fecha_ingreso/salida': '12:00:00/16:30:00'},
      {'estado': 'Hecho', 'fecha_ingreso/salida': '12:00:00/17:30:00'},
      {'estado': 'Hecho', 'fecha_ingreso/salida': '12:30:00/16:30:00'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: Text(
          'Historial',
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
                    leading:
                        const Icon(Icons.adjust, size: 34, color: Colors.green),
                    title: Text(residencias[index]['estado']!),
                    subtitle: Text(residencias[index]['fecha_ingreso/salida']!),
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
