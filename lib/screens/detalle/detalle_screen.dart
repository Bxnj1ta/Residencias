import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class DetalleScreen extends StatefulWidget {
  const DetalleScreen({super.key});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Residencia Casa Calle'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(const Color(0xFF6A4FC9)), // Morado suave
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                  image: AssetImage('lib/assets/image/imagen_login.jpg'),
                  fit: BoxFit.cover,
                ),
                ),
              ),
              const SizedBox(height: 20),

              // Checkbox
              CheckboxListTile(
                title: const Text(
                  "Ingreso",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
                value: _isChecked,
                onChanged: _isChecked
                    ? null // Si ya está activado, desactiva la función
                    : (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.white,
                checkColor: Color(0xFF6A4FC9),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 20),

              _buildSeccionConDetalle(
                titulo: 'Dirección',
                icon: Icons.location_on,
                contenido: 'Avenida ...',
              ),
              const SizedBox(height: 16),

              _buildSeccionConDetalle(
                titulo: 'Horario',
                icon: Icons.calendar_month,
                contenido: '17/05/2025; 12:00 AM',
              ),
              const SizedBox(height: 16),

              _buildSeccionConDetalle(
                titulo: 'Estado',
                icon: Icons.info_outline,
                contenido: 'En Proceso',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionConDetalle({
    required String titulo,
    required IconData icon,
    required String contenido,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1E9FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  contenido,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecoration(Color color) => BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
      ],
    );
