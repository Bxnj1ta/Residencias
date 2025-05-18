import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool showProfileIcon;
  final bool showMenuIcon;

  const CustomAppBar({
    super.key,
    required this.titulo,
    this.showProfileIcon = true,
    this.showMenuIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showMenuIcon
          ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: IconButton(
                icon: const Icon(Icons.menu, size: 30),
                onPressed: () {
                  // ABRIR DRAWER
                },
              ),
          )
          : null,
      elevation: 0,
      toolbarHeight: 80, 
      centerTitle: true, 
      title: Text(titulo),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {
              showProfileIcon
                ? Navigator.pushNamed(context, 'perfil')
                : Navigator.of(context).pop();
            },
            icon: Icon(
              showProfileIcon 
              ? Icons.account_circle 
              : Icons.close,size: 30,),
          ),
        ),
      ],
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}