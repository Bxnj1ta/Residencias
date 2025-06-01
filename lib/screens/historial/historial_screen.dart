import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/themes/my_themes.dart';
import 'package:residencias/ui/ui.dart';
import 'package:residencias/widgets/widgets.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaProvider>(
      builder: (context, agenda, _) {
        final rPendientes = agenda.residenciasUsuario
        .where((r) => r['home_clean_register_state'] == 'Finalizado')
        .toList();

        if (agenda.cargando) {
          return Center(child: CircularProgressIndicator());
        }
        if (agenda.error != null) {
          return ReintentarContainer(
            textError: 'Error al obtener agenda',
            error: agenda.error,
            onRetry: () => agenda.cargarAgenda(),
          );
        }
        if (rPendientes.isEmpty) {
          return Scaffold(
            appBar: const CustomAppBar(titulo: 'Residencias del Día'),
            body: Center(
              child: Text(
                'No hay residencias realizadas en los últimos 30 días.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        
        return Scaffold(
          appBar: const CustomAppBar(titulo: 'Residencias del Día'),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12), // Margen uniforme en todos los bordes
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rPendientes.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(height: 12,), // Espacio antes del primer elemento
                          ResidenciaCard(
                            colorEstado: MyTheme.greenMarker,
                            nombreResidencia: rPendientes[index]['home_data_name'] .toString(),
                            direccionResidencia: rPendientes[index]['home_data_address'] .toString(),
                            onTap: () {
                              Navigator.pushNamed( context, 'detalle', arguments: rPendientes[index], );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



// Card(
//   margin: const EdgeInsets.symmetric( horizontal: 16, vertical: 8, ),
//   shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30), ),
//   child: ListTile(
//     leading: const Icon(
//       Icons.adjust,
//       //Color amarillo para estados "en proceso", rojo para estados "pendiente"
//       size: 34,
//       color: Colors.yellow,
//     ),
//     title: Text(residencias[index]['nombre']!),
//     subtitle: Text(residencias[index]['distancia']!),
//     trailing: const Icon(Icons.chevron_right),
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//     onTap: () {
//       Navigator.pushNamed( context, 'detalle', arguments: residencias[index], );
//     },
//   ),
// );