import 'package:geolocator/geolocator.dart' as gl;

class LocationService {
  Future<bool> checkServicioYPermiso() async {
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

  Future<gl.Position?> getLastKnownPosition() async {
    return await gl.Geolocator.getLastKnownPosition();
  }

  Future<gl.Position> getCurrentPosition() async {
    return await gl.Geolocator.getCurrentPosition();
  }

  Stream<gl.Position> getPositionStream({int distanceFilter = 100}) {
    return gl.Geolocator.getPositionStream(
      locationSettings: gl.LocationSettings(
        accuracy: gl.LocationAccuracy.best,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
