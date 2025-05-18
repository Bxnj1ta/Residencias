import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class DetalleScreen extends StatelessWidget {
  const DetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> residencia = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Residencias del Día',showProfileIcon: false,showMenuIcon: false,),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: MapaDetalle(residencia: residencia))
        ),
    );
  }
}