import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/climate.dart';


class ClimateBarChart extends StatelessWidget {
  final List<ClimateData> data;

  ClimateBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 50,
        barGroups: _createBarGroups(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(data[index].year);
                }
                return Text('');
              },
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    List<BarChartGroupData> barGroups = [];
    // skip every other three year to avoid crowding the x-axis

print("data.length: ${data.length}");

   for (int i = 135; i < data.length; i++) {
      List<BarChartRodData> rods = [];
      for (int j = 0; j < data[i].monthlyValues.length; j++) {
        rods.add(BarChartRodData(
          toY: data[i].monthlyValues[j].toDouble(),
          color: Colors.blue,
          width: 5,
        ));
      }
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: rods,
      ));
    }
    return barGroups;
  }
}