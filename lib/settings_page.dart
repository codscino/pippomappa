import 'package:flutter/material.dart';

import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.store});
  final StoreDirectory store;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
      stream: widget.store.stats.watchChanges(),
      builder: (context, _) {
        return Center(child: Text('Cache size: ${widget.store.stats.storeSize}'));
      },
    ));
  }
}
