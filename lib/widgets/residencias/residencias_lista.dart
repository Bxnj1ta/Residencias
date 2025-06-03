import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';
import 'package:residencias/widgets/residencias/residencia_card.dart';

class ResidenciasLista extends StatelessWidget {
  final List pendientes;
  final Map enProceso;

  const ResidenciasLista({super.key, required this.pendientes, required this.enProceso});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12), // Margen uniforme en todos los bordes
            child: Column(
              children: [
                if (enProceso.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ResidenciaCard(
                    colorEstado: MyTheme.yellowMarker,
                    nombreResidencia: enProceso['home_data_name'].toString(),
                    direccionResidencia: enProceso['home_data_address'].toString(),
                    onTap: () {
                      Navigator.pushNamed( context, 'detalle', arguments: enProceso);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: pendientes.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (enProceso.isEmpty) const SizedBox(height: 12),
                          ResidenciaCard(
                            colorEstado: MyTheme.blueMarker,
                            nombreResidencia: pendientes[index]['home_data_name'] .toString(),
                            direccionResidencia: pendientes[index]['home_data_address'] .toString(),
                            onTap: () {
                              Navigator.pushNamed( context, 'detalle', arguments: pendientes[index], );
                            },
                          ),
                          if (enProceso.isNotEmpty) const SizedBox(height: 12), // Espacio antes del primer elemento
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}