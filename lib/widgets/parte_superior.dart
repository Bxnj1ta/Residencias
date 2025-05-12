import 'package:flutter/material.dart';

class ParteSuperiorScreen extends StatelessWidget {
  final String titulo;
  const ParteSuperiorScreen({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 26, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, 'lista');
            },
          ),
          Text(
            titulo,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          IconButton(
            icon:
                const Icon(Icons.account_circle, size: 26, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, 'perfil');
            },
          ),
        ],
      ),
    );
  }
}
