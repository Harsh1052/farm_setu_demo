import 'package:farm_setu_demo/features/weather_chart/presentations/screen/charts_screen.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/screen/table_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dependencies_injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          child: child ?? const SizedBox.shrink(),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        );
      },
      routes: {
        '/chart_screen': (context) => const ClimateDataPage(),
        '/table_screen': (context) => const TableViewScreen(),
      },
      initialRoute: '/chart_screen',
      home: const ClimateDataPage(),
    );
  }
}
