import 'package:flutter/material.dart';
import 'package:residencias/api/services/api_service.dart';
import 'package:residencias/utils/blacklist.dart';

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
      final List<Map<String, dynamic>> residencias = agendaHoy.cast<Map<String, dynamic>>();
      final Set<String> latLngSet = {};
      residenciasUsuario = residencias.where((r) {
        final latLng = '${r['home_data_latitude']}${r['home_data_length']}';
        final nombre = r['home_data_name']?.toString() ?? '';
        if (!esNombreResidenciaPermitido(nombre)) {
          return false;
        }
        if (latLngSet.contains(latLng)) {
          return false;
        } else {
          latLngSet.add(latLng);
          return true;
        }
      }).toList();
      debugPrint('Residencias del día: $residenciasUsuario');
    } catch (e) {
      error = e.toString();
    }
    cargando = false;
    notifyListeners();
  }

  bool hayResidenciaEnProceso() {
    return residenciasUsuario.any((r) => r['home_clean_register_state'] == 'Proceso');
  }

  int? idResidenciaEnProceso() {
    final r = residenciasUsuario.firstWhere(
      (r) => r['home_clean_register_state'] == 'Proceso',
      orElse: () => {},
    );
    return r.isNotEmpty ? r['home_clean_register_id'] as int : null;
  }
}
