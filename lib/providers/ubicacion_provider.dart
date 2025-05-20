import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UbicacionProvider extends ChangeNotifier {
  Position? _posicion;

  Position? get posicion => _posicion;

  Future<void> obtenerUbicacion() async {
    bool permiso = await Geolocator.requestPermission() != LocationPermission.denied;
    if (!permiso) return;
    _posicion = await Geolocator.getCurrentPosition();
    notifyListeners();
  }
}