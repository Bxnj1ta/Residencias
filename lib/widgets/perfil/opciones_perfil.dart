import 'package:flutter/material.dart';

class OpcionesPerfilScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const OpcionesPerfilScreen(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
