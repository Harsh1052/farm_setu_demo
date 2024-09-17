import 'package:farm_setu_demo/core/models/APIResponse.dart';
import 'package:farm_setu_demo/features/weather_chart/domain/entities/climate.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/weather_chart_repository.dart';

class GetWeatherChartData
    extends UseCase<APIResponse<List<ClimateData>>, GetWeatherChartDataParams> {
  final WeatherChartRepository repository;

  GetWeatherChartData(this.repository);

  @override
  Future<APIResponse<List<ClimateData>>> call(
      GetWeatherChartDataParams params) async {
    return await repository.getWeatherChartDataByCountryURL(params.countryURL,params.isTableData);
  }
}

class GetWeatherChartDataParams {
  final String countryURL;
  final bool isTableData;

  GetWeatherChartDataParams(this.countryURL,this.isTableData);
}
