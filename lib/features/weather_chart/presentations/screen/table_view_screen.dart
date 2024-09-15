import 'package:farm_setu_demo/dependencies_ijection.dart';
import 'package:farm_setu_demo/features/weather_chart/data/models/climate.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/bloc/climate_chart_bloc.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/bloc/climate_chart_events.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/bloc/climate_chart_state.dart';
import 'package:farm_setu_demo/models/climate_table_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TableViewScreen extends StatelessWidget {
  const TableViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt<ClimateChartBloc>()..add(FetchClimateData('https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/England.txt',true)),
        child: Scaffold(
          appBar: AppBar(title: const Text('UK Climate Data')),
          body: BlocBuilder<ClimateChartBloc,ClimateChartState>(
            builder: (context, state) {
              if(state is ClimateLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(state is ClimateLoaded){
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _buildColumns(),
                      rows: _buildRows(state.climateData),
                    ),
                  ),
                );
              }
              if(state is ClimateError){
                return Center(
                  child: Text(state.message),
                );
              }
              return Center(
                child: Text('No Data'),
              );

            },
          ),
        ));
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text('Year')),
      for (int i = 1; i <= 17; i++) DataColumn(label: Text(getMonthName(i)))
    ];
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      case 13:
        return 'Win.';
      case 14:
        return 'Spr.';

      case 15:
        return 'Sum.';
      case 16:
        return 'Aut.';
      case 17:
        return 'Ann.';
      default:
        return '';
    }
  }

  List<DataRow> _buildRows(List<ClimateData> data) {
    return data.map((climateData) {
      debugPrint(climateData.monthlyValues.length.toString());

      return DataRow(cells: [
        DataCell(Text(climateData.year)),
        for (int i = 0; i < climateData.monthlyValues.length; i++)
          DataCell(Text(climateData.monthlyValues[i] <= 0
              ? '--'
              : climateData.monthlyValues[i].toStringAsFixed(1))),
      ]);
    }).toList();
  }
}
