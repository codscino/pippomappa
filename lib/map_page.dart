import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {super.key, required this.damagedDatabaseDeleted, required this.store});

  final bool damagedDatabaseDeleted;
  final StoreDirectory store;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  // dialog box database error
  void initState() {
    if (widget.damagedDatabaseDeleted) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('At least one corrupted database has been deleted.'),
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String urlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    //'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png';

    return Scaffold(
        body: Column(children: [
      Flexible(
          child: FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9,
          maxZoom: 19,
          maxBounds: LatLngBounds.fromPoints([
            LatLng(-90, 180),
            LatLng(90, 180),
            LatLng(90, -180),
            LatLng(-90, -180),
          ]),
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          keepAlive: true,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: Uri.parse(urlTemplate).host,
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: urlTemplate,
            tileProvider: widget.store.getTileProvider(
              FMTCTileProviderSettings(
                  behavior: CacheBehavior.cacheFirst,
                  cachedValidDuration: const Duration(days: 30), //recache every month
                  maxStoreLength: 15000), //less than 350mb, 
                                          //deletes old tiles if max length is surpassed
            ),
            maxZoom: 19,
            userAgentPackageName: 'dev.org.fmtc.example.app',
            panBuffer: 3,
            backgroundColor: const Color(0xFFaad3df),
          ),
        ],
      ))
    ]));
  }
}
