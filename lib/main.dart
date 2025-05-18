import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:residencias/themes/my_themes.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';
void main() async {
  //await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Residencias',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
    );
  }
}
// FUNC MAPA