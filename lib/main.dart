import 'package:farm_setu_demo/features/weather_chart/presentations/screen/charts_screen.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/screen/table_view_screen.dart';
import 'package:farm_setu_demo/routes.dart';
import 'package:flutter/material.dart';
import 'dependencies_injection.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await di.setupGetIt();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}
