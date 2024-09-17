import 'package:farm_setu_demo/core/models/APIResponse.dart';

import '../entities/climate.dart';

abstract class WeatherChartRepository {
  Future<APIResponse<List<ClimateData>>>
      getWeatherChartDataByCountryURL(String countryURL,bool isTableData);
}