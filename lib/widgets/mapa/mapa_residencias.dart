import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:provider/provider.dart';
import 'package:residencias/providers/agenda_provider.dart';
import 'package:image/image.dart' as img;

class MapaResidencias extends StatefulWidget {
  const MapaResidencias({super.key});

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
  //ubicación inicial
  Future<void> _initLocation() async {
    try {
      await _checkServicioYPermiso();
      //para que el mapa cargue mas rapido
      final last = await gl.Geolocator.getLastKnownPosition();
      if (last != null) {
        setState(() => _position = last);
      }
      //obtiene la ubicación actual y actualiza si es diferente
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
    super.dispose();
  }
  //revisa permisos y servicios de ubicación
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
      mp.LocationComponentSettings(enabled: true),
    );
    
    mapboxMapController?.addInteraction(
      mp.TapInteraction(mp.FeaturesetDescriptor(layerId: "residencias-layer"), 
      (feature, context) {
        if (!(feature.properties.containsKey('point_count'))) {
          final id = feature.properties['id'];
          // Busca la residencia en el provider
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

  }
  //Provider->Residencias->geojson. y suscribir al stream con listen.
  void _onMapLoaded(mp.MapLoadedEventData _) async {
    _mapLoaded = true;
    final agenda = Provider.of<AgendaProvider>(context, listen: false);
    if (_position != null && agenda.residenciasUsuario.isNotEmpty) {
      await _agregarGeoJsonSource(agenda.residenciasUsuario);
    }
    //cada 100m, revisar si el puck esta fuera del mapa
    userPositionStream?.cancel();
    userPositionStream = gl.Geolocator
        .getPositionStream(locationSettings: const gl.LocationSettings(
          accuracy: gl.LocationAccuracy.best,
          distanceFilter: 100,
        ))
        .listen(_actualizarUbicacion);
  }

  Future<void> _agregarGeoJsonSource(List<Map<String, dynamic>> residenciasUsuario) async {
    try {
      //asegurarse que tiene latlng
      final features = residenciasUsuario
          .where((r) => r['home_data_length'] != null && r['home_data_latitude'] != null)
          .map((r) => {
                "type": "Feature",
                "geometry": {
                  "type": "Point",
                  "coordinates": [r['home_data_length'], r['home_data_latitude']]
                },
                "properties": {
                  "id": r['home_clean_register_id']?.toString() ?? '',
                  "estado": (r['home_clean_register_state'] ?? '').toString().toLowerCase(),
                }
              })
          .toList();
      final geojson = {
        "type": "FeatureCollection",
        "features": features,
      };
      // Cargar el icono azul y añadirlo al estilo del mapa
      final byteData = await rootBundle.load('lib/assets/icons/blue_marker.png');
      final markerBytes = byteData.buffer.asUint8List();
      final decoded = img.decodeImage(markerBytes);
      if (decoded == null) {
        _mostrarSnackBar("No se pudo cargar iconos.");
        return;
      }
      final mbxImage = mp.MbxImage(
        width: decoded.width,
        height: decoded.height,
        data: markerBytes,
      );
      await mapboxMapController?.style.addStyleImage(
        "blue_marker",          //image id, lo importante
        1.0,                    //escala
        mbxImage,               //imagen
        false,                  //sdf
        <mp.ImageStretches>[],  //eje x
        <mp.ImageStretches?>[], //eje y
        null                    //contenido
      );
      //aqui se crea GeoJSON
      final source = mp.GeoJsonSource(
        id: "residencias-source",
        data: jsonEncode(geojson),
        cluster: true,
        clusterRadius: 50, //que tan cerca los marcadores para agruparse
        clusterMaxZoom: 22, //tolerancia de zoom hasta que rompa el cluster(creo)
      );
      await mapboxMapController?.style.addSource(source);

      //layer para clusters (círculo)
      final clusterCircleLayer = mp.CircleLayer(
        id: "clusters",
        sourceId: "residencias-source",
        filter: ["has", "point_count"],
        circleColorExpression: [
          "step", ["get", "point_count"], "#3fa7d6", 10, "#3fa7d6", 30, "#3fa7d6"
        ],
        circleRadiusExpression: [
          "step", ["get", "point_count"], 18, 10, 22, 30, 28
        ],
      );
      await mapboxMapController?.style.addLayer(clusterCircleLayer);

      //layer para el número de residencias en el cluster
      final clusterCountLayer = mp.SymbolLayer(
        id: "cluster-count",
        sourceId: "residencias-source",
        filter: ["has", "point_count"],
        textFieldExpression: ["to-string", ["get", "point_count"]],
        textSize: 14.0,
        textColorExpression: ["literal", "#ffffff"],
      );
      await mapboxMapController?.style.addLayer(clusterCountLayer);

      //layer para los puntos individuales
      final layer = mp.SymbolLayer(
        id: "residencias-layer",
        sourceId: "residencias-source",
        filter: ["!", ["has", "point_count"]],
        iconImage: "blue_marker",
        iconSize: 0.2,
        iconAllowOverlap: false, //mostrar los iconos individuales
      );
      await mapboxMapController?.style.addLayer(layer);
    } catch (e) {
      _mostrarSnackBar("Error al cargar marcadores.");
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
    if (_position == null || agenda.cargando) {
      return Center(child: CircularProgressIndicator(color: Theme.of(context).progressIndicatorTheme.color));
    }
    if (agenda.error != null) {
      return Center(
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

