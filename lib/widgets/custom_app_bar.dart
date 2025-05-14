import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const CustomAppBar({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0,
      toolbarHeight: 80, 
      centerTitle: true, 
      title: Text(titulo),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12, top: 8),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'perfil');
            },
            icon: const Icon(Icons.account_circle, size: 30),
          ),
        ),
      ],
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}