import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/map_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool damagedDatabaseDeleted = false;
  await FlutterMapTileCaching.initialise(
    errorHandler: (error) => damagedDatabaseDeleted = error.wasFatal,
    debugMode: true,
  );

  await FMTC.instance.rootDirectory.migrator.fromV6(urlTemplates: []);

  if (prefs.getBool('reset') ?? false) {
    await FMTC.instance.rootDirectory.manage.reset();
  }

  // store creation
  final store = FMTC.instance('storeCazzo');
  await store.manage.createAsync(); // Does nothing if the store already exists.

  runApp(AppContainer(
      damagedDatabaseDeleted: damagedDatabaseDeleted, store: store));
}

class AppContainer extends StatelessWidget {
  const AppContainer(
      {super.key, required this.damagedDatabaseDeleted, required this.store});

  final bool damagedDatabaseDeleted;
  final store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FMTC Example',
        debugShowCheckedModeBanner: false,
        home: MapPage(
            damagedDatabaseDeleted: damagedDatabaseDeleted, store: store));
  }
}
