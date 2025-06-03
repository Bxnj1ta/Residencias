import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:residencias/ui/custom_app_bar.dart';
import 'package:residencias/ui/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; //lo primero que muestra es el menu inicio

  // Estado para el buscador y búsqueda
  bool _mostrarBuscador = false;
  String _busqueda = '';

  //POR SI DSP TENEMO QUE CAMBIAR LAS PAGINAS
  // DailyScreen ahora recibe parámetros
  List<Widget> get _pages => <Widget>[
    HistorialScreen(
      mostrarBuscador: _mostrarBuscador && _selectedIndex == 0,
      busqueda: _selectedIndex == 0 ? _busqueda : '',
      onBusquedaChanged: (value) {
        if (_selectedIndex == 0) {
          setState(() {
            _busqueda = value;
          });
        }
      },
    ),
    DailyScreen(
      mostrarBuscador: _mostrarBuscador && _selectedIndex == 1,
      busqueda: _selectedIndex == 1 ? _busqueda : '',
      onBusquedaChanged: (value) {
        if (_selectedIndex == 1) {
          setState(() {
            _busqueda = value;
          });
        }
      },
    ),
    MapaScreen(),
  ];

  // Configuración centralizada del AppBar para cada página
  List<Map<String, dynamic>> get _appBarConfigs => [
    {
      'titulo': 'Historial de residencias',
      'iconA': Icons.refresh,
      'iconB': Icons.search,
      'actionB': _toggleBuscador,
    },
    {
      'titulo': 'Residencias del día',
      'iconA': Icons.refresh,
      'iconB': Icons.search,
      'actionB': _toggleBuscador,
    },
    {
      'titulo': 'Residencias cercanas',
      'iconA': Icons.refresh,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Limpiar búsqueda y ocultar buscador al cambiar de pestaña
      _mostrarBuscador = false;
      _busqueda = '';
    });
  }

  void _refreshAgenda() {
    // Busca el provider y recarga la agenda
    final agendaProvider = context.read<AgendaProvider>();
    agendaProvider.cargarAgenda();
  }

  void _toggleBuscador() {
    setState(() {
      _mostrarBuscador = !_mostrarBuscador;
      if (!_mostrarBuscador) _busqueda = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarConfig = _appBarConfigs[_selectedIndex];

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        titulo: appBarConfig['titulo'],
        iconA: appBarConfig['iconA'],
        actionA: _refreshAgenda,
        iconB: appBarConfig['iconB'],
        actionB: appBarConfig['actionB'],
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