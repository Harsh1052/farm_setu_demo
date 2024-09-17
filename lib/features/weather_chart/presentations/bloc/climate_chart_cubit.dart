
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_weather_chart_data.dart';
import 'climate_chart_state.dart';

class ClimateChartCubit extends Cubit<ClimateChartState> {
  final GetWeatherChartData repository;

  ClimateChartCubit({required this.repository}) : super(ClimateLoading());

  Future<void> fetchClimateData(String countryURL, bool isTableData) async {
    try {
      emit(ClimateLoading());
      final response = await repository(GetWeatherChartDataParams(countryURL, isTableData));
      if (response.error == null) {
        emit(ClimateLoaded(response.data!));
      } else {
        emit(ClimateError(response.error!));
      }
    } catch (e) {
      emit(ClimateError('Something went wrong!!'));
    }
  }
}