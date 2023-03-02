import 'package:flutter/material.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './map_page.dart';
import './settings_page.dart';

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

class AppContainer extends StatefulWidget {
  const AppContainer(
      {super.key, required this.damagedDatabaseDeleted, required this.store});

  final bool damagedDatabaseDeleted;
  final StoreDirectory store;

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  // initialize vars
  late int _selectedIndex;
  late PageController _pageController;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
    _pageController = PageController(initialPage: _selectedIndex);
    _pages = <Widget>[
      MapPage(
          damagedDatabaseDeleted: widget.damagedDatabaseDeleted,
          store: widget.store), // MapPage
      SettingsPage(store: widget.store), // SettingsPage
    ];
  }

  // navbar function
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  @override
  // disposing the pagecontroller apparently is better for perfomance and memory leaks
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FMTC Example',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // pageview used because with AutomaticKeepAliveClientMixin in map_page.dart it
          // keeps the state of the map_page when going back and forth in the bottomnavbar
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            onTap: _onItemTapped,
          ),
        ));
  }
}
