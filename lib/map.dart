import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:latlong2/latlong.dart';

import './marker_list.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: [
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(51.5, -0.09),
                zoom: 4,
                interactiveFlags: InteractiveFlag.all &
                    ~InteractiveFlag.rotate, // avoid map rotation
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: () {},
                )
              ],
              children: [
                TileLayer(
                  urlTemplate: 
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  //'https://mapserver.mapy.cz/base-en/{z}-{x}-{y}',          // base english
                  // 'https://mapserver.mapy.cz/turist-en/{z}-{x}-{y}',       // outdoor english
                  // 'https://mapserver.mapy.cz/winter-en-down/{z}-{x}-{y}',  // winter english
                  // 'https://mapserver.mapy.cz/bing/{z}-{x}-{y}',            // satellite english
                  
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
