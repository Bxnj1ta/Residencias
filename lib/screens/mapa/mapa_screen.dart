import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class MapaScreen extends StatelessWidget {
  const MapaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: MapaResidencias())
        ),
    );
  }
}
