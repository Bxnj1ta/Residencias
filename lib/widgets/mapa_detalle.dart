import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:residencias/widgets/mapa_base.dart';

class MapaDetalle extends StatefulWidget {
  final Map<String, dynamic> residencia;

  const MapaDetalle({
    super.key,
    required this.residencia,
    });

  @override
  State<MapaDetalle> createState() => _MapaDetalleState();
}

class _MapaDetalleState extends State<MapaDetalle> {
  String? _mapStyle;
  LatLng? _miUbicacion;
  Set<Marker> _marcadores = {};


  @override
  void initState() {
    super.initState();
    _cargarEstiloMapa();
    _obtenerUbicacion();
  }

  Future<void> _cargarEstiloMapa() async { //da estilo al mapa
    _mapStyle = await rootBundle.loadString('lib/assets/map/map_style.txt');
  }

  Future<void> _obtenerUbicacion() async { //Pide permisos -> obtiene ubicacion -> cambia el estado
    bool permiso = await Geolocator.requestPermission() != LocationPermission.denied;
    if (!permiso) return;
    final posicion = await Geolocator.getCurrentPosition();
    if (!mounted) return; //por si cierra la pantalla antes de que se obtenga la ubicacion
    setState(() {
      _miUbicacion = LatLng(posicion.latitude, posicion.longitude);
      _crearMarcadores();
    });
  }

  void _crearMarcadores() { //Mi ubicacion y la residencia seleccionada
    final Set<Marker> nuevos = {
      Marker( //el usuario
        markerId: const MarkerId('yo'),
        position: _miUbicacion!,
        infoWindow: const InfoWindow(title: 'Mi ubicación'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(//la residencia
        markerId: MarkerId(widget.residencia['id'].toString()),
        position: LatLng(widget.residencia['lat'], widget.residencia['lng']),
        infoWindow: InfoWindow(
          title: widget.residencia['nombre'],
          snippet: widget.residencia['direccion'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
    _marcadores = nuevos;
  }

  @override
  Widget build(BuildContext context) {
    if (_miUbicacion == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final LatLng residenciaLatLng = LatLng(
      widget.residencia['lat'],
      widget.residencia['lng'],
    );

    return MapaBase(
      marcadores: _marcadores, 
      centerPosition: residenciaLatLng,
      mapStyle: _mapStyle,
    );
  }
}
