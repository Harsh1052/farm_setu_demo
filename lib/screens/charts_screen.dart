import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/bar_chart.dart';
import '../custom_widgets/climate_chart_widget.dart';
import '../models/climate.dart';
import '../providers/weather_provider.dart';

class ClimateDataPage extends StatelessWidget {
  const ClimateDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    // make screen landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return ChangeNotifierProvider(
      create: (context) => WeatherProvider()..loadClimateData(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('UK Climate Data'),
            actions: [
              Consumer<WeatherProvider>(builder: (context, provider, child) {
                return PopupMenuButton(
                    itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 0,
                            child: Text('Bar Chart'),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text('Line Chart'),
                          ),
                        ],
                    onSelected: (int index) {
                      provider.selectedChartIndex = index;
                    });
              })
            ],
          ),
          body: Consumer<WeatherProvider>(
            builder: (context, provider, _) {
              if (provider.climateData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return selectedChart(
                  provider.selectedChartIndex, provider.climateData);
            },
          )),
    );
  }

  // chart options

  Widget selectedChart(int index, List<ClimateData> data) {
    switch (index) {
      case 0:
        return ClimateBarChart(data: data);
      case 1:
        return ClimateChart(data: data);
      default:
        return ClimateBarChart(data: data);
    }
  }
}
