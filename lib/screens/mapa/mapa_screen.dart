import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final double? lat = args != null ? (args['lat'] is double ? args['lat'] : double.tryParse(args['lat'].toString())) : null;
    final double? lng = args != null ? (args['lng'] is double ? args['lng'] : double.tryParse(args['lng'].toString())) : null;
    final bool permitirTapResidencia = args != null && args['permitirTapResidencia'] == false ? false : true;
    final bool seguirUsuario = args != null && args['seguirUsuario'] == false ? false : true;
    final double? zoom = args != null ? args['zoom'] as double? : null;

    // Solo pasamos null como initialPosition, el mapa se centra con initialCameraLat/lng
    return Scaffold(
      body: SafeArea(
        child: MapaResidencias(
          initialPosition: null,
          initialCameraLat: lat,
          initialCameraLng: lng,
          initialZoom: zoom,
          permitirTapResidencia: permitirTapResidencia,
          seguirUsuario: seguirUsuario,
        ),
      ),
    );
  }
}
