import 'package:farm_setu_demo/core/network/network_state.dart';
import 'package:farm_setu_demo/features/weather_chart/data/datasources/climate_data_from_local.dart';
import 'package:farm_setu_demo/features/weather_chart/data/datasources/climate_data_from_server.dart';
import 'package:farm_setu_demo/features/weather_chart/data/repositories/weather_chart_repository_impl.dart';
import 'package:farm_setu_demo/features/weather_chart/domain/usecases/get_weather_chart_data.dart';
import 'package:farm_setu_demo/features/weather_chart/presentations/bloc/climate_chart_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/weather_chart/domain/repositories/weather_chart_repository.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async{

   getIt.registerFactory(() => ClimateChartCubit(repository: getIt()));

   
   getIt.registerLazySingleton(()=>GetWeatherChartData(getIt()));
  getIt.registerLazySingleton<WeatherChartRepository>(() =>
      WeatherChartRepositoryImpl(
          networkState: getIt(),
          climateDataFromLocal: getIt(),
          climateDataFromServer: getIt()));

   //getIt.registerLazySingleton(() => GetWeatherChartData(getIt()));

    getIt.registerLazySingleton<NetworkState>(() => NetworkStateImpl(getIt()));
  getIt.registerLazySingleton<ClimateDataFromServer>(()=> ClimateDataFromServerImpl());
  getIt.registerLazySingleton<ClimateDataFromLocal>(()=> ClimateDataFromLocalImpl());

   final sharedPreferences = await SharedPreferences.getInstance();
   getIt.registerLazySingleton(() => sharedPreferences);
   getIt.registerLazySingleton(()=>InternetConnectionChecker());



}
