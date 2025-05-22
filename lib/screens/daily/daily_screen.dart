import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';
import 'package:residencias/widgets/widgets.dart';
import 'package:residencias/mocks/mock2.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> r = mock2;

    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Residencias del Día'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: r.length,
              itemBuilder: (context, index) {
                return ResidenciaCard(
                  nombreResidencia: r[index]['home_data_name'].toString(), 
                  direccionResidencia: r[index]['home_data_address'].toString(), 
                  onTap: (){
                    Navigator.pushNamed(context,'detalle',arguments:r[index],);
                  }
                );
              },
            ),
          ),
        ],
      ),
      //bottomNavigationBar: const BotonAbajoScreen(),
    );
  }
}



// Card(
//   margin: const EdgeInsets.symmetric( horizontal: 16, vertical: 8, ),
//   shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30), ),
//   child: ListTile(
//     leading: const Icon(
//       Icons.adjust,
//       //Color amarillo para estados "en proceso", rojo para estados "pendiente"
//       size: 34,
//       color: Colors.yellow,
//     ),
//     title: Text(residencias[index]['nombre']!),
//     subtitle: Text(residencias[index]['distancia']!),
//     trailing: const Icon(Icons.chevron_right),
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//     onTap: () {
//       Navigator.pushNamed( context, 'detalle', arguments: residencias[index], );
//     },
//   ),
// );