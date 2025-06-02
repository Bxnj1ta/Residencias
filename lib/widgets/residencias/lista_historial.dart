import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';
import 'package:residencias/widgets/residencias/residencia_card.dart';

class ListaHistorial extends StatelessWidget {
  final List pendientes;
  const ListaHistorial({super.key, required this.pendientes});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: pendientes.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(height: 12,),
                          ResidenciaCard(
                            colorEstado: MyTheme.greenMarker,
                            nombreResidencia: pendientes[index]['home_data_name'] .toString(),
                            direccionResidencia: pendientes[index]['home_data_address'] .toString(),
                            onTap: () {
                              Navigator.pushNamed( context, 'detalle', arguments: pendientes[index], );
                            },
                          ),
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