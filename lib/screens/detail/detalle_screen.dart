import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class ResidenciaDetalleScreen extends StatefulWidget {
  const ResidenciaDetalleScreen({super.key});

  @override
  State<ResidenciaDetalleScreen> createState() => _ResidenciaDetalleScreenState();
}

class _ResidenciaDetalleScreenState extends State<ResidenciaDetalleScreen> {
  bool _isChecked = false; // Variable de estado para el checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Residencia Casa Calle'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(const Color.fromARGB(255, 136, 85, 203)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                decoration: _cardDecoration(Colors.white),
                child: const Center(
                  child: Text('Colocar mapa'),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("Ingreso", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      value: _isChecked, 
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              _buildSeccionConDetalle(
                titulo: 'Dirección',
                icon: Icons.location_on,
                contenido: 'Avenida ...',
              ),
              const SizedBox(height: 20),

              _buildSeccionConDetalle(
                titulo: 'Horario',
                icon: Icons.calendar_month_sharp,
                contenido: '17/05/2025; 12:00 AM',
              ),
              const SizedBox(height: 20),

              _buildSeccionConDetalle(
                titulo: 'Estado',
                icon: Icons.info,
                contenido: 'En Proceso',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionConDetalle({required String titulo, required IconData icon,required String contenido}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 221, 255),
            border: Border.all(color: const Color.fromARGB(255, 151, 121, 191)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                contenido,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
BoxDecoration _cardDecoration(color) => BoxDecoration(
            color: color,
            border: Border.all(color: const Color.fromARGB(255, 151, 121, 191)),
            borderRadius: BorderRadius.circular(20),
          );