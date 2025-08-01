import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/themes/my_themes.dart';
import 'package:residencias/api/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleCard extends StatefulWidget {
  final Map<String, dynamic> residencia;
  final VoidCallback? onTap;

  const DetalleCard({super.key, required this.residencia, this.onTap});

  @override
  State<DetalleCard> createState() => _DetalleCardState();
}

class _DetalleCardState extends State<DetalleCard> {
  final api = ApiService();
  late String estado;
  Position? posicion;
  double? distanciaMetros;

  static const double _rangoPermitido = 30;
  static const String _msgErrorDistancia = 'No se pudo calcular la distancia.';
  static const String _msgFueraRango = 'Debes estar más cerca de la residencia.';

  bool _cargando = false;
  String? _estadoPrevio;

  @override
  void initState() {
    super.initState();
    estado = widget.residencia['home_clean_register_state'].toString();
  }

  Future<void> _cambiarEstado() async {
    setState(() {
      _cargando = true;
      _estadoPrevio = estado;
    });
    final id = widget.residencia['home_clean_register_id'];
    bool ok = false;
    final bool? enRango = await estaEnRango();

    if (!mounted) return;

    if (enRango == null) {
      _mostrarSnackBar(_msgErrorDistancia);
      setState(() => _cargando = false);
      return;
    }
    if (!enRango) {
      _mostrarSnackBar(_msgFueraRango);
      setState(() => _cargando = false);
      return;
    }

    if (estado == 'Pendiente') {
      ok = await api.empezarResidencia(id);
      if (ok) estado = 'Proceso';
    } else if (estado == 'Proceso') {
      ok = await api.finalizarResidencia(id);
      if (ok) estado = 'Finalizado';
    }

    if (!mounted) return;

    if (ok) await context.read<AgendaProvider>().cargarAgenda();
    if (!mounted) return;

    setState(() {
      _cargando = false;
      _estadoPrevio = null;
    });

    _mostrarSnackBar(
      ok
        ? 'Estado cambiado a ${estado.toLowerCase()}'
        : 'Error al cambiar estado',
    );
  }

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void mostrarMapa() async {
    final latRaw = widget.residencia['home_data_latitude'];
    final lngRaw = widget.residencia['home_data_length'];
    final double? lat = latRaw is double ? latRaw : double.tryParse(latRaw.toString());
    final double? lng = lngRaw is double ? lngRaw : double.tryParse(lngRaw.toString());
    if (lat == null || lng == null) {
      _mostrarSnackBar('No se pudo obtener la ubicación de la residencia.');
      return;
    }
    Navigator.pushNamed(
      context,
      'mapa',
      arguments: {
        'lat': lat,
        'lng': lng,
        'permitirTapResidencia': false, // para evitar loops
        'seguirUsuario': false, // NO trakear usuario, solo centrar en residencia
        'zoom': 18.0, // zoom centrado en la residencia
        'desdeDetalle': true, // para mostrar botón atrás
      },
    );
  }

  void abrirRuta(double lat, double lng) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=transit';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (!mounted) return;
      _mostrarSnackBar('No se pudo abrir Google Maps');
    }
  }

  Future<double?> _distancia(double lat, double lng) async {
    try {
      posicion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      distanciaMetros = Geolocator.distanceBetween(
        posicion!.latitude, posicion!.longitude, 
        lat, lng
      );
      return distanciaMetros;
    } catch (_) {
      return null;
    }
  }

  Future<bool?> estaEnRango() async {
    final lat = widget.residencia['home_data_latitude'];
    final lng = widget.residencia['home_data_length'];
    double? distancia = await _distancia(lat, lng);
    if (distancia == null) return null;
    return distancia <= _rangoPermitido;
  }
  
  @override
  Widget build(BuildContext context) {
    final agendaProvider = context.watch<AgendaProvider>();
    final bool hayEnProceso = agendaProvider.hayResidenciaEnProceso();
    final int? idEnProceso = agendaProvider.idResidenciaEnProceso();
    final int? idActual = widget.residencia['home_clean_register_id'];
    final double? lat = widget.residencia['home_data_latitude'];
    final double? lng = widget.residencia['home_data_length'];

    final bool esPendiente = estado == 'Pendiente';
    final bool esProceso = estado == 'Proceso';
    // final bool esFinalizado = estado == 'Finalizado';

    final puedeIngresar = esPendiente && !hayEnProceso;
    final puedeFinalizar = esProceso && (idActual == idEnProceso);

    return Card(
      margin: const EdgeInsets.all(24),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect( //imagen
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                '${widget.residencia['home_data_image']}.png',
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: MyTheme.primary.shade300,
                  child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row( //nombre
              children: [
                Icon(Icons.home, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(widget.residencia['home_data_name'].toString(),
                    style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row( //direccion
              children: [
                Icon(Icons.location_on, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.residencia['home_data_address']?.toString() ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row( //fecha y hora
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  widget.residencia['home_clean_register_date']?.toString() ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Icon(Icons.access_time, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  '${widget.residencia['home_clean_register_clean_init']} - ${widget.residencia['home_clean_register_clean_end']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row( //direcciones y mapa
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ //despues refactorizar
                OutlinedButton.icon(
                  onPressed: () {
                    if (lat != null && lng != null) {
                      abrirRuta(lat, lng);
                    }
                  },
                  icon: Icon(Icons.directions, color: Theme.of(context).iconTheme.color),
                  label: const Text("Cómo llegar"),
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
                OutlinedButton.icon(
                  onPressed: mostrarMapa,
                  icon: Icon(Icons.map, color: Theme.of(context).iconTheme.color),
                  label: const Text("Ver en el mapa"),
                  style: Theme.of(context).outlinedButtonTheme.style,
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon( //Ingresar - Finalizar
              onPressed: (_cargando || !(puedeIngresar || puedeFinalizar)) ? null : _cambiarEstado,
              icon: _cargando
                  ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(
                      esPendiente 
                        ? Icons.login 
                        : Icons.check_circle, 
                    ),
              label: Text(
                _cargando
                  ? (_estadoPrevio == 'Pendiente' ? "Ingresando..." : _estadoPrevio == 'Proceso' ? "Finalizando..." : "Finalizado")
                  : (esPendiente ? "Ingresar" 
                    : esProceso ? "Finalizar" 
                    : "Finalizado")),
            ),
          ],
        ),
      ),
    );
  }
}