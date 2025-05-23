import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiUrl => dotenv.env['API_BASE_URL']!;
  static String get username => dotenv.env['USERNAME']!;
  static String get password => dotenv.env['PASSWORD']!;
}
