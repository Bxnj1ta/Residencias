import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Residencias cercanas'),
      body: MapaResidencias(),
    );
  }
}
