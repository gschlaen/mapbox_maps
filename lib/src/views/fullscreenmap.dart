import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  // mapController es null hasta que se constriye el mapa
  // Ahi se llama al metodo _onMapCreated y se establece
  // mapController = controller
  MapboxMapController? mapController;
  final latLng = const LatLng(-34.95132147240775, -54.936226245210534);
  String selectedStyle = 'mapbox://styles/rschlaen/cky953x1j4nzz14pat6uzpfkw';
  final darkStyle = 'mapbox://styles/rschlaen/cky94yxwe3nq915o1b66080nu';
  final streetStyle = 'mapbox://styles/rschlaen/cky953x1j4nzz14pat6uzpfkw';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    // _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController!.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController!.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Simbolos
        FloatingActionButton(
          child: const Icon(Icons.sentiment_very_dissatisfied),
          onPressed: () {
            mapController!.addSymbol(SymbolOptions(
              geometry: latLng,
              // iconSize: 3,
              iconImage: 'networkImage',
              textField: 'Montaña creada aqui',
              textOffset: const Offset(0, 3),
            ));
          },
        ),

        const SizedBox(height: 5),

        // ZoomIn
        FloatingActionButton(
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            mapController!.animateCamera(CameraUpdate.zoomIn());
          },
        ),

        const SizedBox(height: 5),

        // ZoomOut
        FloatingActionButton(
          child: const Icon(Icons.zoom_out),
          onPressed: () {
            mapController!.animateCamera(CameraUpdate.zoomOut());
          },
        ),

        const SizedBox(height: 5),

        FloatingActionButton(
          child: const Icon(Icons.add_to_home_screen),
          onPressed: () {
            if (selectedStyle == darkStyle) {
              selectedStyle = streetStyle;
            } else {
              selectedStyle = darkStyle;
            }
            // _onStyleLoaded();
            setState(() {});
          },
        )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 14,
      ),
    );
  }
}
