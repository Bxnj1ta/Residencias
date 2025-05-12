import 'package:flutter/material.dart';

class BotonAbajoScreen extends StatelessWidget {
  const BotonAbajoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, 'historial');
                },
              ),
              const Text('Historial',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, 'lista');
                },
              ),
              const Text('Inicio',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.map, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, 'mapa');
                },
              ),
              const Text('Mapa',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
