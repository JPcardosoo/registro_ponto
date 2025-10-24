import 'package:cloud_firestore/cloud_firestore.dart';

class PontoModel {
  final String userId;
  final Timestamp timestamp;
  final GeoPoint location;
  final String type;

  PontoModel({
    required this.userId,
    required this.timestamp,
    required this.location,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'timestamp': timestamp,
      'location': location,
      'type': type,
    };
  }
}