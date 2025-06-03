import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:residencias/env/config.dart';
import 'package:residencias/models/estado.dart';
// import 'package:residencias/models/residencia.dart';
//test main
class ApiService {
  final String baseUrl = EnvConfig.apiUrl;
  final String username = EnvConfig.username;
  final String password = EnvConfig.password;
  String get basicAuth => 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Future<List<dynamic>> obtenerAgendaDia() async {
    final url = Uri.parse('$baseUrl/schedule_list_current/');
    final res = await http.get(
      url,
      headers: {
        'authorization': basicAuth,
      },
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['list_current'];
    } else {
      return [];//falta errores
    }
  }

  Future<bool> empezarResidencia(int id) async {
    final Estado estado = Estado(
      homeScheduleId: id, //id = residencia['home_clean_register_id']
      homeScheduleState: 'Proceso',
    );
    final url = Uri.parse('$baseUrl/schedule_change_state/');
    final res = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(estado.toJson()),
    );
    return res.statusCode == 200;
  }
  
  Future<bool> finalizarResidencia(int id) async {
    final Estado estado = Estado(
      homeScheduleId: id, //id = residencia['home_clean_register_id']
      homeScheduleState: 'Finalizado',
    );
    final url = Uri.parse('$baseUrl/schedule_change_state/');
    final res = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(estado.toJson()),
    );
    return res.statusCode == 200;
  }

  // Simulación de autenticacion ya que no hay endpoint
  Future<Map<String, dynamic>> fakeLogin(String email, String password) async {
    // Simular que solo ciertos correos/contraseñas son válidos
    if (email == 'admin@residencias.com' && password == '123456') {
      return {'success': true};
    } else {
      return {'success': false, 'error': 'Correo o contraseña inválidos'};
    }
  }
} 