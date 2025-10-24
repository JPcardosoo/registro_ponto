import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sa_registro_ponto/controllers/ponto_controller.dart';
import 'package:sa_registro_ponto/models/locations_points.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PontoController _controller = PontoController();
  final List<LocationsPoints> _listaPosicoesSalvas = [];
  LatLng? _pontoTocado;
  bool _isLoading = false;
  final MapController _mapController = MapController();

  void _executarRegistroCompleto() async {
    if (_pontoTocado == null) return;

    setState(() {
      _isLoading = true;
    });

    final String? resultado = await _controller.registrarPonto(_pontoTocado!);

    if (!mounted) return;

    if (resultado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ponto registrado com sucesso no Firebase!'),
          backgroundColor: Colors.green,
        ),
      );
      _salvarPontoLocalmente();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resultado),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _salvarPontoLocalmente() {
    setState(() {
      final novoPonto = LocationsPoints(
        latitude: _pontoTocado!.latitude,
        longitude: _pontoTocado!.longitude,
        timeStamp: DateTime.now().toIso8601String(),
      );
      _listaPosicoesSalvas.add(novoPonto);
      _pontoTocado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Registro de Ponto",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 76, 175, 80),
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: FirebaseAuth.instance.signOut,
              icon: Icon(Icons.logout),
              color: Colors.white,
              tooltip: "Sair",
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (_pontoTocado == null || _isLoading)
            ? null
            : _executarRegistroCompleto,
        backgroundColor: (_pontoTocado == null || _isLoading)
            ? Colors.grey
            : Color.fromARGB(255, 76, 175, 80),
        elevation: 4,
        icon: _isLoading
            ? Container(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.save_rounded, color: Colors.white),
        label: Text(
          "Salvar Ponto",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(-22.570833, -47.403889),
          initialZoom: 15,
          onTap: (tapPosition, point) {
            setState(() {
              _pontoTocado = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.sa_registro_ponto",
          ),
          MarkerLayer(
            markers: [
              ..._listaPosicoesSalvas.map((ponto) {
                return Marker(
                  point: LatLng(ponto.latitude, ponto.longitude),
                  child: Icon(Icons.location_on, color: Colors.red, size: 35),
                );
              }),
              if (_pontoTocado != null)
                Marker(
                  point: _pontoTocado!,
                  child: Icon(Icons.location_on, color: Colors.blue, size: 35),
                ),
            ],
          ),
        ],
      ),
    );
  }
}