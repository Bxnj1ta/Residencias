import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, size: 64, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Usuario Ejemplo',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('usuario@email.com',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Opciones
          ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
            title: const Text('Perfil'),
            onTap: () => Navigator.pushNamed(context, 'perfil'),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
            title: const Text('Configuración'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar sesión'),
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Residencias v1.0',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
