import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/residencias/residencias_lista.dart';
import 'package:residencias/widgets/residencias/sin_residencias.dart';
import 'package:residencias/widgets/widgets.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  String _busqueda = '';
  bool _mostrarBuscador = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AgendaProvider>(
      builder: (context, agenda, _) {
        final residenciasPendientes = agenda.residenciasUsuario
            .where((r) => r['home_clean_register_state'] == 'Pendiente')
            .where((r) =>
                r['home_data_name']
                    .toString()
                    .toLowerCase()
                    .contains(_busqueda.toLowerCase()) ||
                r['home_data_address']
                    .toString()
                    .toLowerCase()
                    .contains(_busqueda.toLowerCase()))
            .toList();

        final enProceso = agenda.residenciasUsuario.firstWhere(
          (r) => r['home_clean_register_state'] == 'Proceso',
          orElse: () => {},
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Búsqueda de residencias', style: TextStyle(fontSize: 20)),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _mostrarBuscador = !_mostrarBuscador;
                  });
                },
              ),
            ],
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
                      : Column(
                          children: [
                            if (_mostrarBuscador)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Buscar por nombre o dirección',
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _busqueda = value;
                                    });
                                  },
                                ),
                              ),
                            Expanded(
                              child: ResidenciasLista(
                                pendientes: residenciasPendientes,
                                enProceso: enProceso,
                              ),
                            ),
                          ],
                        ),
        );

      },
    );
  }
}
