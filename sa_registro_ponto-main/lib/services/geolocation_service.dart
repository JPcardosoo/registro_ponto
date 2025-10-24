import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeolocationService {
  final double workLatitude = -22.570833;
  final double workLongitude = -47.403889;
  final double maxDistanceInMeters = 100.0;

  bool isLocationWithinWorkRadius(LatLng location) {
    double distance = Geolocator.distanceBetween(
      workLatitude,
      workLongitude,
      location.latitude,
      location.longitude,
    );
    print('Distância calculada: $distance metros.');
    return distance <= maxDistanceInMeters;
  }
}