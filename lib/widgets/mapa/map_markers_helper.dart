import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mp;
import 'package:image/image.dart' as img;

class MapMarkersHelper {
  static Future<void> agregarGeoJsonSource({
    required mp.MapboxMap mapboxMapController,
    required List<Map<String, dynamic>> residenciasUsuario,
    required Function(String) mostrarSnackBar,
  }) async {
    try {
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
      final iconos = {
      "pendiente": "lib/assets/icons/blue_marker.png",
      "finalizado": "lib/assets/icons/green_marker.png",
      "proceso": "lib/assets/icons/yellow_marker.png",
      };

      for (final entry in iconos.entries) {
        final byteData = await rootBundle.load(entry.value);
        final markerBytes = byteData.buffer.asUint8List();
        final decoded = img.decodeImage(markerBytes);
        if (decoded == null) {
          mostrarSnackBar("No se pudo cargar icono ${entry.key}.");
          continue;
        }
        final mbxImage = mp.MbxImage(
          width: decoded.width,
          height: decoded.height,
          data: markerBytes,
        );
        await mapboxMapController.style.addStyleImage(
          entry.key,
          1.0,
          mbxImage,
          false,
          <mp.ImageStretches>[],
          <mp.ImageStretches?>[],
          null,
        );
      }
      final source = mp.GeoJsonSource(
        id: "residencias-source",
        data: jsonEncode(geojson),
        cluster: true,
        clusterRadius: 50,
        clusterMaxZoom: 22,
        // clusterProperties para propagar si hay una residencia en proceso (máximo una)
        clusterProperties: {
          'has_proceso': [
            'max',
            [
              'case',
                ["==", ["get", "estado"], "proceso"],
                1,
                0
            ]
          ]
        },
      );
      await mapboxMapController.style.addSource(source);

      final clusterCircleLayer = mp.CircleLayer(
        id: "clusters",
        sourceId: "residencias-source",
        filter: ["has", "point_count"],
        circleColorExpression: [
          "case",
            ["==", ["get", "has_proceso"], 1], "#fac05e", // amarillo si hay proceso
            "#3fa7d6" // azul si no
        ],
        circleRadiusExpression: [
          "step", ["get", "point_count"], 18, 10, 22, 30, 28
        ],
      );
      await mapboxMapController.style.addLayer(clusterCircleLayer);
      final clusterCountLayer = mp.SymbolLayer(
        id: "cluster-count",
        sourceId: "residencias-source",
        filter: ["has", "point_count"],
        textFieldExpression: ["to-string", ["get", "point_count"]],
        textSize: 14.0,
        textColorExpression: ["literal", "#ffffff"],
      );
      await mapboxMapController.style.addLayer(clusterCountLayer);
      final layer = mp.SymbolLayer(
        id: "residencias-layer",
        sourceId: "residencias-source",
        filter: ["!", ["has", "point_count"]],
        iconImageExpression: ["get", "estado"],
        iconSize: 0.2,
        iconAllowOverlap: false,
      );
      await mapboxMapController.style.addLayer(layer);
    } catch (e) {
      mostrarSnackBar("Error al cargar marcadores.");
    }
  }
}
