import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../data/models/climate.dart';


class ClimateChart extends StatelessWidget {
  final List<ClimateData> data;

  const ClimateChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
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
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: _getSpots(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 1,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getSpots() {
    List<FlSpot> spots = [];
    for (int i = 135; i < data.length; i++) {
      double average = data[i].monthlyValues.reduce((a, b) => a + b) / data[i].monthlyValues.length;
      spots.add(FlSpot(i.toDouble(), average));
    }
    return spots;
  }
}