import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';

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
  Uint8List? _markerIcon;
  bool _mapLoaded = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
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
      // El stream de ubicación solo debe suscribirse en _onMapLoaded, no en _initLocation
      // Por lo tanto, elimina esta sección de _initLocation:
      // userPositionStream?.cancel();
      // userPositionStream = gl.Geolocator
      //     .getPositionStream(locationSettings: const gl.LocationSettings(
      //       accuracy: gl.LocationAccuracy.high,
      //       distanceFilter: 100,
      //     ))
      //     .listen(_actualizarUbicacion);
    } catch (e) {
      debugPrint("Error en rastreo de posición: $e");
    }
  }

  @override
  void dispose() {
    userPositionStream?.cancel();
    _pointAnnotationManager?.deleteAll();
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
    if (mapboxMapController == null || !_mapLoaded) return;
    final cameraState = await mapboxMapController!.getCameraState();
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
      await _pointAnnotationManager?.deleteAll();
      _pointAnnotationManager ??= await mapboxMapController?.annotations.createPointAnnotationManager();
      _markerIcon ??= await cargarIconoMarcador();
      //lista de residencas -> limpia LatLng -> mapea anotaciones -> lo pasa a una lista de anotaciones
      final optionsList = residenciasUsuario
          .where((r) => r['home_data_length'] != null && r['home_data_latitude'] != null)
          .map((r) => mp.PointAnnotationOptions(
                geometry: mp.Point(coordinates: mp.Position(r['home_data_length'], r['home_data_latitude'])),
                iconSize: 0.2,
                image: _markerIcon!,
              ))
          .toList();
      if (optionsList.isNotEmpty) {
        await _pointAnnotationManager?.createMulti(optionsList);
      }
    } catch (e) {
      debugPrint("Error al cargar marcador: $e");
    }
  }

  Future<Uint8List> cargarIconoMarcador() async {
    final byteData = await rootBundle.load("lib/assets/icons/marker.png");
    return byteData.buffer.asUint8List();
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
