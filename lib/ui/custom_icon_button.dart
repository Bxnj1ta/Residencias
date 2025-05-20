import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? color;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 28,
    this.color = const Color.fromRGBO(72, 68, 78, 1),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon, 
        size: size, 
        color: color),
      onPressed: onPressed,
      splashRadius: 70,
    );
  }
}
