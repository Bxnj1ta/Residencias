import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'login';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'lista': (BuildContext context) => const DailyScreen(),
    'historial': (BuildContext context) => const HistorialScreen(),
    'mapa': (BuildContext context) => const MapaScreen(),
    'detalle': (BuildContext context) => const DetalleScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
