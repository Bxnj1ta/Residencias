import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/mapa/residencia_annotation_click_listener.dart';

class MapaResidencias extends StatefulWidget {
  const MapaResidencias({super.key});

  @override
  State<MapaResidencias> createState() => _MapaResidenciasState();
}

class _MapaResidenciasState extends State<MapaResidencias> {
  mp.MapboxMap? mapboxMapController;
  gl.Position? _position;
  StreamSubscription<gl.Position>? userPositionStream;
  mp.PointAnnotationManager? _pointAnnotationManager;
  Brightness? _tema;
  Uint8List? _markerIconPendiente;
  Uint8List? _markerIconProceso;
  Uint8List? _markerIconFinalizado;
  bool _mapLoaded = false;

  // Mapa para asociar el id de residencia a su información
  final Map<String, Map<String, dynamic>> _residenciaPorId = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  void _mostrarSnackBar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _initLocation() async {
    try {
      await _checkServicioYPermiso();
      // Usa la última ubicación conocida para mostrar el mapa rápido
      final last = await gl.Geolocator.getLastKnownPosition();
      if (last != null) {
        setState(() => _position = last);
      }
      // Obtiene la ubicación actual y actualiza si es diferente
      final current = await gl.Geolocator.getCurrentPosition();
      if (_position == null ||
          _position!.latitude != current.latitude ||
          _position!.longitude != current.longitude) {
        setState(() {
          _position = current;
          if (mapboxMapController != null) {
            mapboxMapController?.flyTo(
              mp.CameraOptions(
                center: mp.Point(
                  coordinates: mp.Position(_position!.longitude, _position!.latitude),
                ),
                zoom: 14,
              ),
              mp.MapAnimationOptions(duration: 1000),
            );
          }
        });
      }
    } catch (e) {
      _mostrarSnackBar("Error en rastreo de posición.");
    }
  }
  @override
  void dispose() {
    userPositionStream?.cancel();
    // No llamar a _pointAnnotationManager?.deleteAll() aquí para evitar crash
    super.dispose();
  }

  Future<bool> _checkServicioYPermiso() async {
    if (!await gl.Geolocator.isLocationServiceEnabled()) {
      return Future.error('Servicio de ubicación está desactivado.');
    }
    var permission = await gl.Geolocator.checkPermission();
    if (permission == gl.LocationPermission.denied) {
      permission = await gl.Geolocator.requestPermission();
      if (permission == gl.LocationPermission.denied) {
        return Future.error('Permiso de ubicacion denegado.');
      }
    }
    if (permission == gl.LocationPermission.deniedForever) {
      return Future.error('Permiso de ubicación denegado permanentemente.');
    }
    return true;
  }

  Future<void> _actualizarUbicacion(gl.Position position) async {
    if (!mounted || mapboxMapController == null || !_mapLoaded) return;
    try {
      final cameraState = await mapboxMapController!.getCameraState();
      if (!mounted) return;
      final cameraOptions = cameraState.toCameraOptions();
      final bounds = await mapboxMapController!.coordinateBoundsForCamera(cameraOptions);
      final pos = mp.Position(position.longitude, position.latitude);
      final inViewport = pos.lng >= bounds.southwest.coordinates.lng &&
          pos.lng <= bounds.northeast.coordinates.lng &&
          pos.lat >= bounds.southwest.coordinates.lat &&
          pos.lat <= bounds.northeast.coordinates.lat;
      if (!inViewport) {
        mapboxMapController?.flyTo(
          mp.CameraOptions(center: mp.Point(coordinates: pos), zoom: 14),
          mp.MapAnimationOptions(duration: 1000),
        );
      }
    } catch (e) {
      //agregar un print
    }
  }

  void _onMapCreated(mp.MapboxMap controller) async {
    mapboxMapController = controller;
    mapboxMapController?.location.updateSettings(
      mp.LocationComponentSettings(enabled: true),
    );
    // No suscribimos al stream aquí, solo cuando el mapa esté cargado
  }

  void _onMapLoaded(mp.MapLoadedEventData _) async {
    _mapLoaded = true;
    final agenda = Provider.of<AgendaProvider>(context, listen: false);
    if (_position != null && agenda.residenciasUsuario.isNotEmpty) {
      await _agregarMarcadores(agenda.residenciasUsuario);
    }
    // Ahora sí, suscribimos al stream de ubicación
    userPositionStream?.cancel();
    userPositionStream = gl.Geolocator
        .getPositionStream(locationSettings: const gl.LocationSettings(
          accuracy: gl.LocationAccuracy.high,
          distanceFilter: 100,
        ))
        .listen(_actualizarUbicacion);
  }

  Future<void> _agregarMarcadores(List<Map<String, dynamic>> residenciasUsuario) async {
    try {
      // Siempre crea un nuevo manager y reemplaza el anterior
      _pointAnnotationManager = await mapboxMapController?.annotations.createPointAnnotationManager();
      // Limpiar el mapa antes de agregar nuevos
      _residenciaPorId.clear();
      // Cargar íconos de marcadores por estado si no están cargados
      _markerIconPendiente ??= await cargarIconoMarcador('pendiente');
      _markerIconProceso ??= await cargarIconoMarcador('proceso');
      _markerIconFinalizado ??= await cargarIconoMarcador('finalizado');
      final optionsList = residenciasUsuario
          .where((r) => r['home_data_length'] != null && r['home_data_latitude'] != null)
          .map((r) {
            String estado = (r['home_clean_register_state'] ?? '').toString().toLowerCase();
            Uint8List? icono;
            if (estado == 'pendiente') {
              icono = _markerIconPendiente;
            } else if (estado == 'proceso') {
              icono = _markerIconProceso;
            } else if (estado == 'finalizado') {
              icono = _markerIconFinalizado;
            } else {
              icono = _markerIconPendiente; // fallback
            }
            final id = r['home_clean_register_id']?.toString() ?? '';
            if (id.isNotEmpty) {
              _residenciaPorId[id] = r;
            }
            // Usar textField para guardar el id
            return mp.PointAnnotationOptions(
              geometry: mp.Point(coordinates: mp.Position(r['home_data_length'], r['home_data_latitude'])),
              iconSize: 0.5,
              image: icono!,
              textField: id, //la unica forma de referencia el marcador
              textColor: 0x00000000, //trasparente
              textHaloColor: 0x00000000, //trasparente
              textSize: 1, //que no se note
            );
          })
          .toList();
      if (optionsList.isNotEmpty) {
        await _pointAnnotationManager?.createMulti(optionsList);
        if (!mounted) return;
        _pointAnnotationManager?.addOnPointAnnotationClickListener(ResidenciaPushListener(context, _residenciaPorId));
      }
    } catch (e) {
      _mostrarSnackBar("Error al cargar marcadores.");
    }
  }

  Future<Uint8List> cargarIconoMarcador(String estado) async {
    try {
      String path = "lib/assets/icons/";
      if (estado == 'pendiente') {
        path += "blue_marker.png";
      } else if (estado == 'proceso') {
        path += "yellow_marker.png";
      } else if (estado == 'finalizado') {
        path += "green_marker.png";
      } else {
        path += "red_marker.png";
      }
      final byteData = await rootBundle.load(path);
      return byteData.buffer.asUint8List();
    } catch (e) {
      _mostrarSnackBar('Error al cargar el icono del marcador "$estado".');
      rethrow;
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = MediaQuery.of(context).platformBrightness;
    if (_tema != null && brightness != _tema && mapboxMapController != null) {
      final styleUri = brightness == Brightness.dark
          ? mp.MapboxStyles.DARK
          : mp.MapboxStyles.LIGHT;
      mapboxMapController?.style.setStyleURI(styleUri);
    }
    _tema = brightness;
  }

  @override
  Widget build(BuildContext context) {
    final agenda = Provider.of<AgendaProvider>(context);
    if (_position == null || agenda.cargando) {
      return Center(child: CircularProgressIndicator(color: Theme.of(context).progressIndicatorTheme.color));
    }
    if (agenda.error != null) {
      return 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error al obtener agenda: ${agenda.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => agenda.cargarAgenda(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    final brightness = MediaQuery.of(context).platformBrightness;
    final styleUri = brightness == Brightness.dark ? mp.MapboxStyles.DARK : mp.MapboxStyles.LIGHT;
        
    return Stack(
      children: [
        mp.MapWidget(
          onMapCreated: _onMapCreated,
          onMapLoadedListener: _onMapLoaded,
          styleUri: styleUri,
          cameraOptions: mp.CameraOptions(
            center: mp.Point(
              coordinates: mp.Position(_position!.longitude, _position!.latitude),
            ),
            zoom: 14,
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            child: const Icon(Icons.my_location),
            onPressed: () async {
              if (_position != null && mapboxMapController != null) {
                mapboxMapController?.flyTo(
                  mp.CameraOptions(
                    center: mp.Point(
                      coordinates: mp.Position(_position!.longitude, _position!.latitude),
                    ),
                    zoom: 14,
                  ),
                  mp.MapAnimationOptions(duration: 1000),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

