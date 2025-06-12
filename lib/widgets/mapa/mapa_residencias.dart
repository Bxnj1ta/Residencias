import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:residencias/widgets/mapa/location_service.dart';
import 'package:residencias/widgets/mapa/map_markers_helper.dart';

class MapaResidencias extends StatefulWidget {
  final gl.Position? initialPosition;
  final double? initialCameraLat;
  final double? initialCameraLng;
  final bool seguirUsuario;
  final bool permitirTapResidencia;
  final double? initialZoom;
  const MapaResidencias({
    super.key,
    this.initialPosition,
    this.initialCameraLat,
    this.initialCameraLng,
    this.seguirUsuario = true,
    this.permitirTapResidencia = true,
    this.initialZoom,
  });

  @override
  State<MapaResidencias> createState() => _MapaResidenciasState();
}

class _MapaResidenciasState extends State<MapaResidencias> {
  mp.MapboxMap? mapboxMapController;
  gl.Position? _position;
  StreamSubscription<gl.Position>? userPositionStream;
  Brightness? _tema;
  bool _mapLoaded = false;
  late BuildContext _myContext;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _position = widget.initialPosition;
    }

    if (widget.seguirUsuario) {
      _initLocation();
    }
  }

  void _mostrarSnackBar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  //ubicación inicial
  Future<void> _initLocation() async {
    try {
      await _locationService.checkServicioYPermiso();
      if (_position == null) {
        //para que el mapa cargue mas rapido
        final last = await _locationService.getLastKnownPosition();
        if (last != null) {
          setState(() => _position = last);
        }
        //obtiene la ubicación actual y actualiza si es diferente
        final current = await _locationService.getCurrentPosition();
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
      }
    } catch (e) {
      _mostrarSnackBar("Error en rastreo de posición.");
    }
  }
  @override
  void dispose() {
    userPositionStream?.cancel();
    super.dispose();
  }
  //funcion para seguir la ubicacion con la camara
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
  //se crea el controlador y el puck
  void _onMapCreated(mp.MapboxMap controller) async {
    mapboxMapController = controller;
    mapboxMapController?.location.updateSettings(
      mp.LocationComponentSettings(enabled: true), // Sin layerAbove aquí
    );
    // Ocultar la barra de escala (ft/m)
    mapboxMapController?.scaleBar.updateSettings(
      mp.ScaleBarSettings(enabled: false),
    );
    if (widget.permitirTapResidencia) {
      mapboxMapController?.addInteraction(
        mp.TapInteraction(mp.FeaturesetDescriptor(layerId: "residencias-layer"),
        (feature, context) {
          if (!(feature.properties.containsKey('point_count'))) {
            final id = feature.properties['id'];
            final agenda = Provider.of<AgendaProvider>(_myContext, listen: false);
            final residencia = agenda.residenciasUsuario.firstWhere(
              (r) => r['home_clean_register_id'].toString() == id.toString(),
              orElse: () => {},
            );
            if (residencia.isNotEmpty) {
              Navigator.pushNamed(_myContext, 'detalle', arguments: residencia);
            }
          }
        }),
        interactionID: "residenciaTapInteraction",
      );

      mapboxMapController?.addInteraction(
        mp.TapInteraction(mp.FeaturesetDescriptor(layerId: "clusters"), 
        ( feature, context, ) async {
          if (feature.properties.containsKey('point_count')) {
            final coordinates = feature.geometry['coordinates'] as List?;
            if (coordinates != null && coordinates.length >= 2) {
              final lng = coordinates[0];
              final lat = coordinates[1];
              final cameraState = await mapboxMapController?.getCameraState();
              final zoomActual = cameraState != null ? cameraState.zoom : 14.0;
              final nuevoZoom = zoomActual + 3;
              mapboxMapController?.flyTo(
                mp.CameraOptions(
                  center: mp.Point(coordinates: mp.Position(lng, lat)),
                  zoom: nuevoZoom,
                ),
                mp.MapAnimationOptions(duration: 1500),
              );
            } else {
              _mostrarSnackBar("No se pudo obtener la ubicación del cluster.");
            }
          }
        }),
        interactionID: "clusterTapInteraction",
      );
    }
  }
  //Provider->Residencias->geojson. y suscribir al stream con listen.
  void _onMapLoaded(mp.MapLoadedEventData _) async {
    _mapLoaded = true;
    final agenda = Provider.of<AgendaProvider>(context, listen: false);
    // Agregar marcadores aunque _position sea null
    if (agenda.residenciasUsuario.isNotEmpty && mapboxMapController != null) {
      await MapMarkersHelper.agregarGeoJsonSource(
        mapboxMapController: mapboxMapController!,
        residenciasUsuario: agenda.residenciasUsuario,
        mostrarSnackBar: _mostrarSnackBar,
      );
      // Ahora que las capas existen, actualiza el puck encima de cluster-count
      mapboxMapController?.location.updateSettings(
        mp.LocationComponentSettings(enabled: true, layerAbove: "cluster-count"),
      );
    }
    if (widget.seguirUsuario) {
      userPositionStream?.cancel();
      userPositionStream = _locationService.getPositionStream(distanceFilter: 100)
          .listen(_actualizarUbicacion);
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
    _myContext = context;
    final agenda = Provider.of<AgendaProvider>(context);
    if (agenda.cargando) {
      return Center(child: CircularProgressIndicator(color: Theme.of(context).progressIndicatorTheme.color));
    }
    // Si seguirUsuario es false, no es obligatorio tener _position
    if (widget.seguirUsuario && _position == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (agenda.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error al obtener agenda: \\${agenda.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => agenda.cargarAgenda(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }
    // Detectar si el mapa fue abierto desde DetalleScreen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool mostrarBotonAtras = args != null && args['desdeDetalle'] == true;
    final brightness = MediaQuery.of(context).platformBrightness;
    final styleUri = brightness == Brightness.dark ? mp.MapboxStyles.DARK : mp.MapboxStyles.LIGHT;
    final double zoom = widget.initialZoom ?? 14;
    final double? cameraLat = widget.initialCameraLat;
    final double? cameraLng = widget.initialCameraLng;
    // Calcular el centro de la cámara de forma robusta
    mp.Position? cameraCenter;
    if (cameraLat != null && cameraLng != null) {
      cameraCenter = mp.Position(cameraLng, cameraLat);
    } else if (_position != null) {
      cameraCenter = mp.Position(_position!.longitude, _position!.latitude);
    } else {
      cameraCenter = null;
    }

    if (cameraCenter == null) {
      return Center(child: Text('No hay coordenadas para mostrar el mapa.'));
    }
    return Stack(
      children: [
        mp.MapWidget(
          onMapCreated: _onMapCreated,
          onMapLoadedListener: _onMapLoaded,
          styleUri: styleUri,
          cameraOptions: mp.CameraOptions(
            center: mp.Point(coordinates: cameraCenter),
            zoom: zoom,
          ),
        ),
        if (mostrarBotonAtras)
          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'fab_atras',
              shape: CircleBorder(),
              child: const Icon(Icons.arrow_back),
              onPressed: () {
                  Navigator.of(context).pop();
                },
            ),
          ),
        if (!mostrarBotonAtras)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'fab_mylocation',
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
                } else {
                  _mostrarSnackBar('No se pudo centrar la ubicación.');
                }
              },
              tooltip: 'Centrar en mi ubicación',
              child: const Icon(Icons.my_location),
            ),
          ),
      ],
    );
  }
}

