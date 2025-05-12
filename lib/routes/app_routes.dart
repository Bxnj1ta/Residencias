import 'package:flutter/material.dart';
import '../screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const InicioScreen(),
    'lista': (BuildContext context) => const ListaScreen(),
    'historial': (BuildContext context) => const HistorialScreen(),
    'mapa': (BuildContext context) => const MapaScreen(),
    'perfil': (BuildContext context) => const PerfilScreen(),
    //Agregar la pantalla de detalle.
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
