import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaBase extends StatelessWidget {
  final Set<Marker> marcadores;
  final LatLng centerPosition;
  final String? mapStyle;
  final Function(GoogleMapController)? onMapCreated;
  final double zoom;


  const MapaBase({
    super.key,
    required this.marcadores,
    required this.centerPosition,
    this.mapStyle,
    this.onMapCreated,
    this.zoom = 15,
    });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: centerPosition,
        zoom: zoom,
        tilt: 0,
        ),
      markers: marcadores,
      myLocationEnabled: false,
      style: mapStyle,
      buildingsEnabled: false,
      mapType: MapType.normal,
      tiltGesturesEnabled: false,
    );
  }
}