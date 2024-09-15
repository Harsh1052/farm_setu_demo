import 'package:farm_setu_demo/features/weather_chart/presentations/screen/charts_screen.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/screen/table_view_screen.dart';
import 'package:flutter/material.dart';
import 'dependencies_ijection.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await di.setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/chart_screen': (context) => const ClimateDataPage(),
        '/table_screen': (context) => const TableViewScreen(),
      },
      home: const ClimateDataPage(),
    );
  }
}
