import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool showDrawer;
  final VoidCallback? actionA;
  final IconData? iconA;
  final VoidCallback? actionB;
  final IconData? iconB;

  const CustomAppBar({
    super.key,
    required this.titulo,
    this.showDrawer = true,
    this.iconA,
    this.actionA,
    this.iconB,
    this.actionB,
  });

  @override
  Widget build(BuildContext context) {
    final double tramoSuperior = MediaQuery.of(context).padding.top;
    return Container(
      height: preferredSize.height + tramoSuperior,
      padding: EdgeInsets.only(
        top: tramoSuperior,
        left: 12, right: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Botón izquierdo
          Align(
            alignment: Alignment.centerLeft,
            child: showDrawer
              ? CustomIconButton(icon: Icons.menu, onPressed: () {
                  Scaffold.of(context).openDrawer();
                },)
              : CustomIconButton(icon: Icons.arrow_back, onPressed: () {Navigator.of(context).pop();},),
          ),
          // Título centrado
          Center(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Botones derechos
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconB != null && actionB != null)
                  CustomIconButton(
                    icon: iconB!,
                    onPressed: actionB!,
                  ),
                if (iconA != null && actionA != null)
                  CustomIconButton(
                    icon: iconA!,
                    onPressed: actionA!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}