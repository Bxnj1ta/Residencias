import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/residencias/residencias_lista.dart';
import 'package:residencias/widgets/residencias/sin_residencias.dart';
import 'package:residencias/widgets/widgets.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaProvider>(
      builder: (context, agenda, _) {
        final pendientes = agenda.residenciasUsuario
        .where((r) => r['home_clean_register_state'] == 'Pendiente').toList();

        final enProceso = agenda.residenciasUsuario
        .firstWhere((r) => r['home_clean_register_state'] == 'Proceso', orElse: () => {});

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
                      textError: 'Error al obtener agenda',
                      error: agenda.error,
                      onRetry: () => agenda.cargarAgenda(),
                    )
                  : agenda.residenciasUsuario.isEmpty
                      ? SinResidencias()
                      : ResidenciasLista(pendientes: pendientes, enProceso: enProceso),
        );
      },
    );
  }
}

