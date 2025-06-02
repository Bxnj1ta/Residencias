import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/residencias/lista_historial.dart';
import 'package:residencias/widgets/widgets.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaProvider>(
      builder: (context, agenda, _) {
        final finalizados = agenda.residenciasUsuario
        .where((r) => r['home_clean_register_state'] == 'Finalizado') .toList();
        
    
        return Scaffold(
          appBar: CustomAppBar(
            titulo: 'Residencias del Día',
            rightIcon: Icons.refresh,
            onRightPressed: () => agenda.cargarAgenda(),
          ),
          body: agenda.cargando
              ? Center(child: CircularProgressIndicator())
              : agenda.error != null
                  ? ReintentarContainer(
                      textError: 'Error al cargar historial',
                      error: agenda.error,
                      onRetry: () => agenda.cargarAgenda(),
                    )
                  : finalizados.isEmpty
                      ? Center(
                          child: Text(
                            'No hay residencias realizadas en los últimos 30 días.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListaHistorial(pendientes: finalizados),
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