import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final double? lat = args != null ? args['lat'] as double? : null;
    final double? lng = args != null ? args['lng'] as double? : null;
    final String? nombre = args != null ? args['nombre'] as String? : null;
    final bool permitirTapResidencia = args != null && args['permitirTapResidencia'] == false ? false : true;
    final bool seguirUsuario = args != null && args['seguirUsuario'] == false ? false : true;
    final double? zoom = args != null ? args['zoom'] as double? : null;

    return Scaffold(
      appBar: CustomAppBar(titulo: nombre ?? 'Residencias cercanas', showDrawer: false),
      body: MapaResidencias(
        initialPosition: (lat != null && lng != null)
            ? Position(
                latitude: lat,
                longitude: lng,
                timestamp: DateTime.now(),
                accuracy: 0,
                altitude: 0,
                heading: 0,
                speed: 0,
                speedAccuracy: 0,
                altitudeAccuracy: 0,
                headingAccuracy: 0,
              )
            : null,
        permitirTapResidencia: permitirTapResidencia,
        seguirUsuario: seguirUsuario,
        initialZoom: zoom, // Nuevo parámetro
      ),
    );
  }
}
