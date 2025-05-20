import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:residencias/mocks/mock_residencias.dart';
import 'package:residencias/providers/providers.dart'; //LISTA DEMO


class MapaResidencias extends StatefulWidget {
  const MapaResidencias({
    super.key
    });

  @override
  State<MapaResidencias> createState() => _MapaResidenciasState();
}

class _MapaResidenciasState extends State<MapaResidencias> {
  String? _mapStyle;
  Set<Marker> _marcadores = {};
  final List<Map<String, dynamic>> _residencias = mockResidencias; // LISTA MOCK DEL BACKEND

  @override
  void initState() {
    super.initState();
    _cargarEstiloMapa();
  }

  Future<void> _cargarEstiloMapa() async { //da estilo al mapa
    _mapStyle = await rootBundle.loadString('lib/assets/map/map_style.txt');
    setState(() {});
  }

  void _crearMarcadores(LatLng miUbicacion) { //mi Ubicacion y las residencias del user (POR AHORA SOLO MOCK)
    final Set<Marker> nuevos = {
      Marker(
        markerId: const MarkerId('yo'),
        position: miUbicacion,
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
    final ubicacionProvider = Provider.of<UbicacionProvider>(context);
    final posicion = ubicacionProvider.posicion;
    
    if (posicion == null || _mapStyle == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final LatLng miUbicacion = LatLng(posicion.latitude, posicion.longitude);
    _crearMarcadores(miUbicacion);

    return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: miUbicacion,
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
