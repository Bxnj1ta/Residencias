import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/residencias/residencias_lista.dart';
import 'package:residencias/widgets/residencias/sin_residencias.dart';
import 'package:residencias/widgets/widgets.dart';

class DailyScreen extends StatefulWidget {
  final bool mostrarBuscador;
  final String busqueda;
  final ValueChanged<String> onBusquedaChanged;

  static void _defaultOnBusquedaChanged(String value) {}

  const DailyScreen({
    super.key,
    this.mostrarBuscador = false,
    this.busqueda = '',
    this.onBusquedaChanged = _defaultOnBusquedaChanged,
  });

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.busqueda);
  }

  @override
  void didUpdateWidget(DailyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.busqueda != _controller.text) {
      _controller.text = widget.busqueda;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                    .contains(widget.busqueda.toLowerCase()) ||
                r['home_data_address']
                    .toString()
                    .toLowerCase()
                    .contains(widget.busqueda.toLowerCase()))
            .toList();

        final enProceso = agenda.residenciasUsuario.firstWhere(
          (r) => r['home_clean_register_state'] == 'Proceso',
          orElse: () => {},
        );

        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: agenda.cargando
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
                              if (widget.mostrarBuscador)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Buscar por nombre o dirección',
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                    onChanged: widget.onBusquedaChanged,
                                    controller: _controller,
                                  ),
                                ),
                              Expanded(child: ResidenciasLista( pendientes: residenciasPendientes, enProceso: enProceso)),
                            ],
                          ),
          ),
        );
      },
    );
  }
}