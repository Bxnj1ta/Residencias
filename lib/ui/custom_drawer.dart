import 'package:flutter/material.dart';
import 'package:residencias/themes/my_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String correo = 'usuario@ejemplo.com';
  String nombre = 'Usuario Ejemplo';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      correo = prefs.getString('correo') ?? 'usuario@ejemplo.com';
      nombre = prefs.getString('nombre') ?? 'Usuario Ejemplo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Row(
              children: [
                const Icon(Icons.account_circle, size: 64, color: MyTheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nombre,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(correo,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {},//() => Navigator.pushNamed(context, 'perfil')
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn');
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false); //limpia la navegación
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Residencias v0.2',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}