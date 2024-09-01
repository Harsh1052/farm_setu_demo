import 'package:farm_setu_demo/screens/charts_screen.dart';
import 'package:farm_setu_demo/screens/google_map_screen.dart';
import 'package:farm_setu_demo/screens/home_screen.dart';
import 'package:farm_setu_demo/screens/table_view_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/chart_screen': (context) => const ClimateDataPage(),
        '/google_map': (context) => HighlightedMapPage(),
        '/table_view': (context) => const TableViewScreen()
      },
      home: const HomeScreen(),
    );
  }
}
