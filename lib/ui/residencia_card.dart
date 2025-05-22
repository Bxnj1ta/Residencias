import 'package:flutter/material.dart';

class ResidenciaCard extends StatelessWidget {
  final ShapeBorder? shape;
  final String nombreResidencia;
  final String direccionResidencia;
  final VoidCallback onTap;

  const ResidenciaCard({
    super.key,
    this.shape,
    required this.nombreResidencia, // = residencias[index]['home_data_name']
    required this.direccionResidencia, // = residencias[index]['home_data_address']
    required this.onTap,//=Navigator.pushNamed(context,'detalle',arguments:residencias[index],);
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardHeight = constraints.maxHeight;
        double borderRadius = cardHeight / 2;
        borderRadius = borderRadius > 50 ? 50 : borderRadius;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ListTile(
            leading: const Icon(Icons.adjust,size: 34, color: Colors.yellow, ),
            title: Text(nombreResidencia.toString()),
            subtitle: Text(direccionResidencia.toString()),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
