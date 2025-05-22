import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:residencias/mocks/mock_residencias.dart';

class MapaResidencias extends StatefulWidget {
  const MapaResidencias({super.key});

  @override
  State<MapaResidencias> createState() => _MapaResidenciasState();
}

class _MapaResidenciasState extends State<MapaResidencias> {
  mp.MapboxMap? mapboxMapController;
  List<Map<String,dynamic>> residenciasUsuario = [];
  gl.Position? _position;
  StreamSubscription<gl.Position>? userPositionStream;
  mp.PointAnnotationManager? _pointAnnotationManager;

  @override
  void initState() {
    super.initState();
    _obtenerResidencias();
    _positionTracking();
  }
  @override
  void dispose() {
    userPositionStream?.cancel();
    _pointAnnotationManager?.deleteAll();
    super.dispose();
  }
  //revisa permisos y servicio de ubicación
  Future<bool> _checkServicioYPermiso() async {
    if(!await gl.Geolocator.isLocationServiceEnabled()) {
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
  //permisos y servicios -> ubicacion inicial -> escuchar cambios en la ubicacion
  Future<void> _positionTracking() async {
    try {
      //1. resvisa si tiene servicio activado y permisos concedidos.
      await _checkServicioYPermiso();
      //2. con esto el mapa se abre centrado en la posicion actual.
      _position = await gl.Geolocator.getCurrentPosition();
      setState(() {});
      //3. cómo cambia la camara y cuando.
      final settings = gl.LocationSettings(
        accuracy: gl.LocationAccuracy.high,
        distanceFilter: 100,
      );
      userPositionStream?.cancel();//por si ya habia uno.
      userPositionStream = gl.Geolocator
        .getPositionStream(locationSettings: settings)
        .listen(_actualizarUbicacion);
    } catch (e) {
      debugPrint("Error en rastreo de posición: $e");
    }
  }
  //centra la camara en la ubicacion actualizada cada vez que se sale del frame
  Future<void> _actualizarUbicacion(gl.Position position) async {
    if (mapboxMapController == null) return;

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
        mp.MapAnimationOptions(duration: 1000),//ms
      );
    }
  }
  //carga lista de residencias del usuario
  void _obtenerResidencias() {
    residenciasUsuario = mockResidencias;
  }
  //activa el puck y controlador
  void _onMapCreated(mp.MapboxMap controller) async {
    mapboxMapController = controller;
    //muestra el puck en el mapa
    mapboxMapController?.location.updateSettings(
      mp.LocationComponentSettings(enabled: true)
    );
  }
  //muestra los marcadores al cagar el mapa
  void _onMapLoaded(mp.MapLoadedEventData _) {
    agregarMarcadores();
  }
  //agregar marcadores a partir de residenciasUsuario
  Future<void> agregarMarcadores() async {
    return Future.delayed(Duration(milliseconds: 500), () async {
    try {
      await _pointAnnotationManager?.deleteAll();//limpia anotaciones previas
      _pointAnnotationManager = await mapboxMapController?.annotations.createPointAnnotationManager();
      final Uint8List imageData = await cargarIconoMarcador();

      mp.PointAnnotationOptions pointAnnotationOptions = mp.PointAnnotationOptions(
        image: imageData,
        iconSize: 0.2,
        geometry: mp.Point(coordinates: mp.Position(-70.61067676151647, -33.42936938276679)),
      );

      await _pointAnnotationManager?.create(pointAnnotationOptions);
    } catch (e) {
      debugPrint("Error al cargar marcador: $e");
    }
  });
  }
  //carga iconos que se usarán
  Future<Uint8List> cargarIconoMarcador() async {
    var byteData = await rootBundle.load("lib/assets/icons/marker.png");
    return byteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (_position == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return mp.MapWidget(
      onMapCreated: _onMapCreated,
      onMapLoadedListener: _onMapLoaded,
      styleUri: mp.MapboxStyles.LIGHT,
      cameraOptions: mp.CameraOptions(
        center: mp.Point(
          coordinates: mp.Position(_position!.longitude, _position!.latitude),
        ),
        zoom: 14,
      ),
    );
  }
}
