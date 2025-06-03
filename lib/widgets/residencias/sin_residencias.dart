import 'package:flutter/material.dart';

class SinResidencias extends StatelessWidget {
  const SinResidencias({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'No hay residencias asignadas para hoy.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
  }
}