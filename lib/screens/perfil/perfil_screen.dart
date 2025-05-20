import 'package:flutter/material.dart';
import 'package:residencias/widgets/widgets.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titulo: 'Perfil', showDrawer: false,showRightIcon: false,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.purple.shade700, Colors.purple.shade400],
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/women/65.jpg'),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'María González',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Editar Perfil',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  OpcionesPerfilScreen(
                      icon: Icons.favorite,
                      title: 'Mis favoritos',
                      onTap: () {}),
                  OpcionesPerfilScreen(
                      icon: Icons.history,
                      title: 'Historial de visitas',
                      onTap: () {
                        Navigator.pushNamed(context, 'historial');
                      }),
                  OpcionesPerfilScreen(
                      icon: Icons.notifications,
                      title: 'Notificaciones',
                      onTap: () {}),
                  OpcionesPerfilScreen(
                      icon: Icons.help, title: 'Ayuda y soporte', onTap: () {}),
                  OpcionesPerfilScreen(
                      icon: Icons.logout,
                      title: 'Cerrar sesión',
                      onTap: () {
                        Navigator.pushNamed(context, 'home');
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: const BotonAbajoScreen(),
    );
  }
}
