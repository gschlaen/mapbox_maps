// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:mapbox_maps/src/views/fullscreenmap.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        body: const FullScreenMap(),
      ),
    );
  }
}

// Sacar el token secreto del /gradle.properties 
// y verificar que no se sube a github
