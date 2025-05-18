import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';
import 'package:residencias/mocks/mock_residencias.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> residencias = mockResidencias;

    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Residencias del Día'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: residencias.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(255, 219, 199, 245),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    leading: const Icon(Icons.adjust,
                        //Color amarillo para estados "en proceso", rojo para estados "pendiente"
                        size: 34,
                        color: Colors.yellow),
                    title: Text(residencias[index]['nombre']!),
                    subtitle: Text(residencias[index]['distancia']!),
                    trailing: const Icon(Icons.chevron_right),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      Navigator.pushNamed(context, 'detalle', arguments: residencias[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      //bottomNavigationBar: const BotonAbajoScreen(),
    );
  }
}
