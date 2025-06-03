import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:residencias/ui/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; //lo primero que muestra es el menu inicio

  //POR SI DSP TENEMO QUE CAMBIAR LAS PAGINAS
  static final List<Widget> _pages = <Widget>[
    HistorialScreen(), 
    DailyScreen(),    
    MapaScreen(),      
  ];

  // Configuración centralizada del AppBar para cada página
  static final List<Map<String, dynamic>> _appBarConfigs = [
    {
      'titulo': 'Historial de residencias',
      'rightIcon': Icons.refresh,
      'onRightPressed': null, // Se puede personalizar si se requiere
    },
    {
      'titulo': 'Residencias del día',
      'rightIcon': Icons.refresh,
      'onRightPressed': null,
    },
    {
      'titulo': 'Residencias cercanas',
      'rightIcon': null,
      'onRightPressed': null,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarConfig = _appBarConfigs[_selectedIndex];
    return Scaffold(
      appBar: CustomAppBar(
        titulo: appBarConfig['titulo'],
        rightIcon: appBarConfig['rightIcon'],
        onRightPressed: appBarConfig['onRightPressed'],
        showDrawer: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, //al tocar cada icono cambia el index que indica la pagina a mostrar
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.history),label: 'Historial',),
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Inicio',),
          BottomNavigationBarItem(icon: Icon(Icons.map),label: 'Mapa',),
        ],
      ),
    );
  }
}