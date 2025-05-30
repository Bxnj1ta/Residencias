import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ResidenciaPushListener extends OnPointAnnotationClickListener {
  final BuildContext context;
  final Map<String, Map<String, dynamic>> residenciaPorId;
  ResidenciaPushListener(this.context, this.residenciaPorId);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final id = annotation.textField;
    if (id != null && residenciaPorId.containsKey(id)) {
      final residencia = residenciaPorId[id]!;
      //como en daily
      Navigator.pushNamed( context, 'detalle', arguments: residencia);
    }
  }
}
