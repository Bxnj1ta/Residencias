import 'package:flutter/material.dart';
import 'package:residencias/api/services/api_service.dart';

class AgendaProvider extends ChangeNotifier {
  final ApiService api;
  List<Map<String, dynamic>> residenciasUsuario = [];
  bool cargando = false;
  String? error;

  AgendaProvider({ApiService? apiService}) : api = apiService ?? ApiService();

  Future<void> cargarAgenda() async {
    cargando = true;
    error = null;
    notifyListeners();
    try {
      final agendaHoy = await api.obtenerAgendaDia();
      residenciasUsuario = agendaHoy.cast<Map<String, dynamic>>();
      debugPrint('Residencias del día: $residenciasUsuario');
    } catch (e) {
      error = e.toString();
    }
    cargando = false;
    notifyListeners();
  }
}
