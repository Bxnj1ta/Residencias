import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).appBarTheme.iconTheme?.color;
    return IconButton(
      icon: Icon(
        icon, 
        size: size,
        color: color,
      ),
      onPressed: onPressed,
      splashRadius: 70,
    );
  }
}
