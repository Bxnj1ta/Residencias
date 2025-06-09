import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'routes/app_routes.dart';
import 'package:residencias/themes/my_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> setup() async {
  await dotenv.load(
    fileName: ".env",
  );
  MapboxOptions.setAccessToken(
    dotenv.env["MAPBOX_ACCESS_TOKEN"]!
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //login: se asegura que todo está inicializado
  await Firebase.initializeApp(); //Inicializar firebase
  await setup();
  // Verificar si el usuario ya está logueado
  final prefs = await SharedPreferences.getInstance(); //login: se obtiene si está logeado o no
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false; //login: si no hay valor, se asume que no
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = AgendaProvider();
            provider.cargarAgenda();
            return provider;
          },
        ),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),//login:se pasa el estado de login a toda la app
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        //para cambiar la statusbar entre light/dark. no se donde poner esto.
        final brightness = MediaQuery.of(context).platformBrightness;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
            statusBarBrightness: brightness == Brightness.dark ? Brightness.dark : Brightness.light,
          ),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Residencias',
          theme: MyTheme.light,
          darkTheme: MyTheme.dark,
          themeMode: ThemeMode.system,
          initialRoute: isLoggedIn ? 'home' : 'login',//login: se salta el login
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      }
    );
  }
}