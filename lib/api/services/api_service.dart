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

  // Simulación de autenticacion ya que no hay endpoint
  Future<Map<String, dynamic>> fakeLogin(String email, String password) async {
    // Simular que solo ciertos correos/contraseñas son válidos
    if (email == 'admin@residencias.com' && password == '123456') {
      return {'success': true};
    } else {
      return {'success': false, 'error': 'Correo o contraseña inválidos'};
    }
  }

  /*
  // Cuando haya endpoint para validar las credenciales
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login/'); 
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Aquí se puede guardar el token si se devuelve:
      // EnvConfig.token = data['token'];
      return {'success': true, 'data': data};
    } else if (response.statusCode == 401) {
      return {'success': false, 'error': 'Credenciales inválidas'};
    } else {
      return {'success': false, 'error': 'Error inesperado: ${response.statusCode}'};
    }
  }
  */
} 