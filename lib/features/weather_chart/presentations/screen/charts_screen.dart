import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/bloc/climate_chart_bloc.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/bloc/climate_chart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependencies_injection.dart';
import '../../../../routes.gr.dart';
import '../../data/models/climate.dart';
import '../bloc/climate_chart_events.dart';
import '../custom_widgets/bar_chart.dart';
import '../custom_widgets/climate_chart_widget.dart';

@RoutePage()
class ChartData extends StatelessWidget {
  const ChartData({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => getIt<ClimateChartBloc>()..add(FetchClimateData('https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/UK.txt',false)),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('England Climate Data'),
            actions: [
              IconButton(onPressed: (){
                context.router.push(const TableViewRoute());

              }, icon: const Icon(Icons.view_column_outlined))
              /*Consumer<WeatherProvider>(builder: (context, provider, child) {
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
              })*/
            ],
          ),
          body: BlocBuilder<ClimateChartBloc,ClimateChartState>(builder: (context, state) {
            if (state is ClimateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ClimateLoaded) {
              return  Column(
                children: [
                  Expanded(
                    child: selectedChart(0, state.climateData),
                  ),
                ],
              );
            } else if (state is ClimateError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text('No Data'),
              );
            }
          })),
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
