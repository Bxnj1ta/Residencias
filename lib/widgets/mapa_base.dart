import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaBase extends StatefulWidget {
  final Set<Marker> marcadores;
  final LatLng miUbicacion;
  final String? mapStyle;
  final Function(GoogleMapController)? onMapCreated;
  final double zoom;


  const MapaBase({
    super.key,
    required this.marcadores,
    required this.miUbicacion,
    this.mapStyle,
    this.onMapCreated,
    this.zoom = 15,
    });

  @override
  State<MapaBase> createState() => _MapaBaseState();
}

class _MapaBaseState extends State<MapaBase> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}