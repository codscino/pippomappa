import 'package:flutter/material.dart' hide Badge;

import 'map_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.damagedDatabaseDeleted,
  });

  final bool damagedDatabaseDeleted;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
   @override
  Widget build(BuildContext context) => MapPage();
}
