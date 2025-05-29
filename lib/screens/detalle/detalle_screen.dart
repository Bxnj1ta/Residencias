import 'package:flutter/material.dart';
import 'package:residencias/ui/detalle_card.dart';
import 'package:residencias/widgets/widgets.dart';

class DetalleScreen extends StatefulWidget {
  const DetalleScreen({super.key});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> residencia = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: CustomAppBar(titulo: residencia['home_data_name'].toString(), showDrawer: false,),
      body: Center(child: DetalleCard( residencia: residencia)),
    );
  }
}