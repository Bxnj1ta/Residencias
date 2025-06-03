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