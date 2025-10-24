import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/locations_points.dart'; 
class LocationService {
  final DateFormat _formatar = DateFormat("dd/MM/yyyy - HH:mm:ss");


  Future<LocationsPoints> getCurrentLocation() async {
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      throw Exception("O serviço de GPS está desativado.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); 
      if (permission == LocationPermission.denied) {
        throw Exception("Permissão de acesso ao GPS foi negada.");
      }
    }
    
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    
    String dataHora = _formatar.format(DateTime.now());
    
    LocationsPoints posicaoAtual = LocationsPoints(
      latitude: position.latitude,
      longitude: position.longitude,
      timeStamp: dataHora,
    );
    
    return posicaoAtual;
  }
}