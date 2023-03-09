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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: widget.store.stats.watchChanges(),
            builder: (context, _) {
              return Center(
                // -16 because 16 is the min size of a store and i want to show the user a zero when it clears the cache
                  child: Text('Cache size: ${widget.store.stats.storeSize-16}'));
            }),
        const SizedBox(height: 50),
        StreamBuilder(
            stream: widget.store.stats.watchChanges(),
            builder: (context, _) {
              return Center(
               // number of tiles
                  child: Text('Store length: ${widget.store.stats.storeLength}'));
            }),
        const SizedBox(height: 50),
        SizedBox(
          height: 50,
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            heroTag: 'f10',
            onPressed: () {
              widget.store.manage.reset();
            },
            child: const Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
