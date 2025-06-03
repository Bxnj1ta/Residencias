import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/residencias/lista_historial.dart';
import 'package:residencias/widgets/widgets.dart';

class HistorialScreen extends StatefulWidget {
  final bool mostrarBuscador;
  final String busqueda;
  final ValueChanged<String> onBusquedaChanged;

  static void _defaultOnBusquedaChanged(String value) {}

  const HistorialScreen({
    super.key,
    this.mostrarBuscador = false,
    this.busqueda = '',
    this.onBusquedaChanged = _defaultOnBusquedaChanged,
  });

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.busqueda);
  }

  @override
  void didUpdateWidget(covariant HistorialScreen oldWidget) {
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
        final finalizados = agenda.residenciasUsuario
            .where((r) => r['home_clean_register_state'] == 'Finalizado')
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

        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: agenda.cargando
                ? Center(child: CircularProgressIndicator())
                : agenda.error != null
                    ? ReintentarContainer(
                        textError: 'Error al cargar historial',
                        error: agenda.error,
                        onRetry: () => agenda.cargarAgenda(),
                      )
                    : Column(
                        children: [
                          if (widget.mostrarBuscador)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                              child: TextField(
                                controller: _controller,
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
                              ),
                            ),
                          Expanded(
                            child: finalizados.isEmpty
                                ? Center(
                                    child: Text(
                                      'No hay residencias realizadas en los últimos 30 días.',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  )
                                : ListaHistorial(pendientes: finalizados),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}