import 'package:farm_setu_demo/core/models/APIResponse.dart';
import 'package:farm_setu_demo/core/network/network_state.dart';
import 'package:farm_setu_demo/features/weather_chart/data/datasources/climate_data_from_local.dart';
import 'package:farm_setu_demo/features/weather_chart/data/datasources/climate_data_from_server.dart';

import 'package:farm_setu_demo/features/weather_chart/domain/repositories/weather_chart_repository.dart';

import '../../data/models/climate.dart';

class WeatherChartRepositoryImpl implements WeatherChartRepository {
  final NetworkState networkState;
  final ClimateDataFromServer climateDataFromServer;
  final ClimateDataFromLocal climateDataFromLocal;

  WeatherChartRepositoryImpl(
      {required this.networkState,
      required this.climateDataFromLocal,
      required this.climateDataFromServer});

  @override
  Future<APIResponse<List<ClimateData>>> getWeatherChartDataByCountryURL(
    String countryURL,
      bool isTableData,
  ) async {
    late APIResponse<String> responseData;
    if (await networkState.isConnected) {
      responseData =
          await climateDataFromServer.getClimateDataByCountryURL(countryURL);
    } else {
      responseData =
          await climateDataFromLocal.getClimateDataByCountryURL();
    }

    if (responseData.error != null && responseData.data == null) {
      return APIResponse(error: responseData.error ?? 'Error in fetching data');
    }
    climateDataFromLocal.saveClimateDataByCountry(responseData.data!);
    return isTableData?
    APIResponse(data: _parseClimateTableData(responseData.data!))
        :APIResponse(data: _parseClimateData(responseData.data!));
  }

  List<ClimateData> _parseClimateData(String fileContent) {
    List<ClimateData> dataList = [];
    List<String> lines = fileContent.split('\n');

    // Skip header lines (first 5 lines in this case)
    for (int i = 5; i < lines.length; i++) {
      String line = lines[i];
      if (line
          .trim()
          .isEmpty) continue; // Skip empty lines

      List<String> parts = line.split(RegExp(r'\s+')); // Split by whitespace
      if (parts.length < 13) continue; // Ensure there are enough columns

      String year = parts[0];
      List<double> monthlyValues =
      parts.sublist(1, 13).map((v) => double.tryParse(v) ?? 0.0).toList();

      dataList.add(ClimateData(year, monthlyValues));
    }

    return dataList;
  }

  List<ClimateData> _parseClimateTableData(String fileContent) {
    List<ClimateData> climateDataList = [];
    List<String> lines = fileContent.split('\n');

    // Assume data starts from the line where we find "Year" and "Month" headers
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('Year')) {
        continue;
      }
      if (lines[i].trim().isEmpty) {
        continue;
      }
      if (i <= 5) {
        continue;
      }

      List<String> values = lines[i].trim().split(RegExp(r'\s+'));
      String year = values[0];
      List<double> monthlyValues = values.sublist(1).map((e) {
        return double.tryParse(e) ?? 0.0;
      }).toList();
      if (monthlyValues.length > 17) {
        continue;
      }
      if (monthlyValues.length < 17) {
        for (int i = monthlyValues.length; i < 17; i++) {
          monthlyValues.add(0.0);
        }
      }

      climateDataList
          .add(ClimateData( year,  monthlyValues));
    }

    return climateDataList;
  }
}
