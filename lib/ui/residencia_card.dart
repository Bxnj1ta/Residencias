import 'package:flutter/material.dart';

class ResidenciaCard extends StatelessWidget {
  final ShapeBorder? shape;
  final String nombreResidencia;
  final String direccionResidencia;
  final VoidCallback onTap;
  final Color colorEstado;

  const ResidenciaCard({
    super.key,
    this.shape,
    required this.nombreResidencia, // = residencias[index]['home_data_name']
    required this.direccionResidencia, // = residencias[index]['home_data_address']
    required this.onTap,//=Navigator.pushNamed(context,'detalle',arguments:residencias[index],);
    required this.colorEstado,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardHeight = constraints.maxHeight;
        double borderRadius = cardHeight / 2;
        borderRadius = borderRadius > 50 ? 50 : borderRadius;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(Icons.adjust,size: 34, color: colorEstado),
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
