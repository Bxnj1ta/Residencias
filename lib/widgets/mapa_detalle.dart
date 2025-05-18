import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
GoogleMapController? _mapController;
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
    //Pide permisos
    bool permiso = await Geolocator.requestPermission() != LocationPermission.denied;
    if (!permiso) return;
    //obtiene ubicacion
    final posicion = await Geolocator.getCurrentPosition();
    //cambia el estado
    if (!mounted) return; //por si cierra la pantalla antes de que se obtenga la ubicacion
    setState(() {
      _miUbicacion = LatLng(posicion.latitude, posicion.longitude);
      _crearMarcadores();
    });
  }

  void _crearMarcadores() { //agrega a la lista de marcadores: las residencias y la ubicacion
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

  Future<void> _ajustarCamara() async {
    if (_miUbicacion == null || _mapController == null) return;

    final LatLng residenciaLatLng = LatLng(
      widget.residencia['lat'],
      widget.residencia['lng'],
    );

    final bounds = LatLngBounds(
      southwest: LatLng(
        _miUbicacion!.latitude < residenciaLatLng.latitude
            ? _miUbicacion!.latitude
            : residenciaLatLng.latitude,
        _miUbicacion!.longitude < residenciaLatLng.longitude
            ? _miUbicacion!.longitude
            : residenciaLatLng.longitude,
      ),
      northeast: LatLng(
        _miUbicacion!.latitude > residenciaLatLng.latitude
            ? _miUbicacion!.latitude
            : residenciaLatLng.latitude,
        _miUbicacion!.longitude > residenciaLatLng.longitude
            ? _miUbicacion!.longitude
            : residenciaLatLng.longitude,
      ),
    );

  await _mapController!.animateCamera(
    CameraUpdate.newLatLngBounds(bounds, 60), // padding en px
  );
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

    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: residenciaLatLng,
          zoom: 18,
          tilt: 0,
        ),
        markers: _marcadores,
        myLocationEnabled: false,
        onMapCreated: (controller) {
          _mapController = controller;
          _ajustarCamara();
        },
        style: _mapStyle,
        buildingsEnabled: false,
        mapType: MapType.normal,
        tiltGesturesEnabled: false,
        
      );
  }
}
