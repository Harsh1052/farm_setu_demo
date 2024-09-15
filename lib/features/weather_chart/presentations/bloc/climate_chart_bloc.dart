

import 'package:farm_setu_demo/features/weather_chart/data/repositories/weather_chart_repository_impl.dart';
import 'package:farm_setu_demo/features/weather_chart/domain/repositories/weather_chart_repository.dart';
import 'package:farm_setu_demo/services/apis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_weather_chart_data.dart';
import 'climate_chart_events.dart';
import 'climate_chart_state.dart';

class ClimateChartBloc extends Bloc<ClimateChartEvent, ClimateChartState> {
  final APIs  apis = APIs();
  final GetWeatherChartData repository;
  ClimateChartBloc({required this.repository}) : super(ClimateLoading()) {
    on<ClimateChartEvent>((event, emit) async{
      if (event is FetchClimateData) {
        emit(ClimateLoading());
        final response = await repository(GetWeatherChartDataParams(event.countryURL,event.isTableData));
       if(response.error ==null){
          emit(ClimateLoaded(response.data!));
       }else{
          emit(ClimateError(response.error!));
       }
      }

    });
  }


}
