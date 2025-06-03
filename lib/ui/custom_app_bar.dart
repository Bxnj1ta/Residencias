import 'package:flutter/material.dart';
import 'package:residencias/ui/ui.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool showDrawer;
  final bool showRightIcon;
  final VoidCallback? onRightPressed;
  final IconData? rightIcon;

  const CustomAppBar({
    super.key,
    required this.titulo,
    this.showDrawer = true,
    this.showRightIcon = true,
    this.onRightPressed,
    this.rightIcon,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //boton izq
          showDrawer
            ? CustomIconButton(icon: Icons.menu, onPressed: () {
                Scaffold.of(context).openDrawer();
              },)
            : CustomIconButton(icon: Icons.arrow_back, onPressed: () {Navigator.of(context).pop();},),
          //Título
          Expanded(
            child: Center(
              child: Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
    
          //Boton derecho
          showRightIcon
            ? CustomIconButton(
                icon: Icons.refresh,
                onPressed: onRightPressed ?? () {},
              )
            : CustomIconButton(icon: Icons.close, onPressed: () {Navigator.of(context).pop();},),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(58);
}