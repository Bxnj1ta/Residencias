import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:residencias/env/config.dart';
import 'package:residencias/models/estado.dart';
// import 'package:residencias/models/residencia.dart';

class ApiService {
  final String baseUrl = EnvConfig.apiUrl;
  String? _usuario;
  String? _password;
  String get basicAuth => 'Basic ${base64Encode(utf8.encode('$_usuario:$_password'))}';

  void setCredenciales(String usuario, String password) {
    _usuario = usuario;
    _password = password;
  }

  // Future<bool> crearResidencia(Residencia residencia) async {
  //   final url = Uri.parse('$baseUrl/home_create/');
  //   final res = await http.post(
  //     url,
  //     headers: {
  //       'authorization': basicAuth,
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(residencia.toJson()),
  //   );
  //   return res.statusCode == 201; //Residencia creada correctamente
  // }

  // Future<bool> generarAgenda() async {
  //   final url = Uri.parse('$baseUrl/schedule_generation/');
  //   final res = await http.get(
  //     url,
  //     headers: {
  //       'authorization': basicAuth,
  //     },
  //   );
  //   return res.statusCode == 200; //Operación exitosa
  // }

  Future<List<dynamic>> obtenerAgendaDia() async {
    final url = Uri.parse('$baseUrl/schedule_list_current/');
    if (_usuario == null || _password == null) {
      throw Exception('Credenciales no definidas');
    }
    

    final response = await http.get(
      url, 
      headers: {'Authorization': basicAuth}
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['list_current'];
    } else if (response.statusCode == 401) {
      throw Exception('Credenciales inválidas');
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Future<bool> cambiarEstado(Estado estado) async {
  //   final url = Uri.parse('$baseUrl/schedule_change_state/');
  //   final res = await http.post(
  //     url,
  //     headers: {
  //       'authorization': basicAuth,
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(estado.toJson()),
  //   );
  //   return res.statusCode == 200;
  // }

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
} 