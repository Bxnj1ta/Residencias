import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:residencias/env/config.dart';
import 'package:residencias/models/estado.dart';
import 'package:residencias/models/residencia.dart';

class ApiService {
  final String baseUrl = EnvConfig.apiUrl;
  final String username = EnvConfig.username;
  final String password = EnvConfig.password;
  String get basicAuth => 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Future<bool> crearResidencia(Residencia residencia) async {
    final url = Uri.parse('$baseUrl/home_create/');
    final res = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(residencia.toJson()),
    );
    return res.statusCode == 201; //Residencia creada correctamente (Endpoint POST /home_create/)
  }

  Future<bool> generarAgenda() async {
    final url = Uri.parse('$baseUrl/schedule_generation/');
    final res = await http.get(
      url,
      headers: {
        'authorization': basicAuth,
      },
    );
    return res.statusCode == 200; //Operación exitosa (Endpoint GET /schedule_generation/)
  }

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
      return [];//falta errores (Endpoint GET /schedule_list_current/)
    }
  }

  Future<bool> cambiarEstado(Estado estado) async {
    final url = Uri.parse('$baseUrl/schedule_change_state/');
    final res = await http.post(
      url,
      headers: {
        'authorization': basicAuth,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(estado.toJson()),
    );
    return res.statusCode == 200; //Enpoint POST /schedule_change_state/
  }
}
