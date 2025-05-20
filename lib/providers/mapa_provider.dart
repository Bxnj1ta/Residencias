import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaProvider extends ChangeNotifier {
  GoogleMapController? _controller;
  Set<Marker> _marcadores = {};

  void setController(GoogleMapController controller) {
    _controller = controller;
  }

  GoogleMapController? get controller => _controller;

  Set<Marker> get marcadores => _marcadores;

  void agregarMarcador(Marker marker) async {
    _marcadores.add(marker);
    notifyListeners();
  }

  void limpiarMarcadores() async {
    _marcadores.clear();
    notifyListeners();
  }
}