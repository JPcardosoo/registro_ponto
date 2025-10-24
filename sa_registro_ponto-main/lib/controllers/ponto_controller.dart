import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:sa_registro_ponto/models/ponto.dart';
import '../services/geolocation_service.dart';

class PontoController {
  final GeolocationService _geoDistanceService = GeolocationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registrarPonto(LatLng pontoSelecionado) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return "Usuário não autenticado.";
    }

    try {
      final bool isAtWork =
          _geoDistanceService.isLocationWithinWorkRadius(pontoSelecionado);
      if (!isAtWork) {
        return "O ponto selecionado está fora do raio de 100 metros.";
      }

      final PontoModel novoPonto = PontoModel(
        userId: user.uid,
        timestamp: Timestamp.now(),
        location: GeoPoint(pontoSelecionado.latitude, pontoSelecionado.longitude),
        type: 'entrada',
      );

      await _firestore.collection('registros_ponto').add(novoPonto.toMap());

      return null;
    } on Exception catch (e) {
      return e.toString().replaceAll("Exception: ", "");
    } catch (e) {
      return "Ocorreu um erro inesperado. Tente novamente.";
    }
  }
}