import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:residencias/mocks/mock_residencias.dart'; //LISTA DEMO


class MapaResidencias extends StatefulWidget {
  const MapaResidencias({super.key});

  @override
  State<MapaResidencias> createState() => _MapaResidenciasState();
}

class _MapaResidenciasState extends State<MapaResidencias> {
  String? _mapStyle;
  // GoogleMapController? _mapController;
  LatLng? _miUbicacion;
  Set<Marker> _marcadores = {};

  // LISTA MOCK DEL BACKEND
  final List<Map<String, dynamic>> _residencias = mockResidencias;

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
      Marker(
        markerId: const MarkerId('yo'),
        position: _miUbicacion!,
        infoWindow: const InfoWindow(title: 'Mi ubicación'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    };

    for (var r in _residencias) {
      nuevos.add(
        Marker(
          markerId: MarkerId(r['id'].toString()),
          position: LatLng(r['lat'], r['lng']),
          infoWindow: InfoWindow(
            title: r['nombre'],
            snippet: r['direccion'],
            onTap: () => Navigator.pushNamed(context, 'detalle', arguments: r),
          ),
        ),
      );
    }

    _marcadores = nuevos;
  }

  @override
  Widget build(BuildContext context) {
    if (_miUbicacion == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _miUbicacion!,
          zoom: 15,
          tilt: 0,
        ),
        markers: _marcadores,
        myLocationEnabled: false,
        // onMapCreated: (controller) => _mapController = controller,
        style: _mapStyle,
        buildingsEnabled: false,
        mapType: MapType.normal,
        tiltGesturesEnabled: false,
        
      );
  }
}
