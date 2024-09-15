import 'package:farm_setu_demo/core/models/APIResponse.dart';
import 'package:farm_setu_demo/core/network/network_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/climate_data_from_local.dart';
import '../../data/datasources/climate_data_from_server.dart';
import '../../data/models/climate.dart';
import '../../data/repositories/weather_chart_repository_impl.dart';


class WeatherProvider extends ChangeNotifier {
  final WeatherChartRepositoryImpl _weatherChartRepositoryImpl =
      WeatherChartRepositoryImpl(
    networkState: NetworkStateImpl(InternetConnectionChecker()),
    climateDataFromServer: ClimateDataFromServerImpl(),
    climateDataFromLocal: ClimateDataFromLocalImpl(),
  );

  late APIResponse apiResponse;
  List<ClimateData> _climateData = [];
  String _selectedYear = '2024';
  String _selectedMonth = '';
  final Set<Polygon> _polygons = {};
  LatLng _center = const LatLng(54.0, -2.0);

  int _selectedChartIndex = 0;

  int get selectedChartIndex => _selectedChartIndex;

  LatLng get center => _center;

  String get selectedYear => _selectedYear;

  String get selectedMonth => _selectedMonth;

  Set<Polygon> get polygons => _polygons;

  set selectedMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
  }

  set selectedYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setCenter(LatLng center) {
    _center = center;
    notifyListeners();
  }

  set selectedChartIndex(int index) {
    _selectedChartIndex = index;
    notifyListeners();
  }

  List<ClimateData> get climateData => _climateData;
  late SharedPreferences _shredPreference;

  init() async {
    _shredPreference = await SharedPreferences.getInstance();
    checkLocalContent();
  }

  loadClimateData() async {
    /*final fileContent = await downloadFile(
        'https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/UK.txt');
    _shredPreference.setString('data', fileContent);
    _shredPreference.setString('dateTime', DateTime.now().toString());
    _climateData = _parseClimateData(fileContent);*/

    apiResponse = await _weatherChartRepositoryImpl.getWeatherChartDataByCountryURL(
        'https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/UK.txt',false);
    _climateData = apiResponse.data;
    notifyListeners();
  }

  void checkLocalContent() {
    final localData = getDataLocally();
    if (localData != null) {
      _climateData = _parseClimateData(localData);
      notifyListeners();
    } else {
      loadClimateData();
    }
  }

  String? getDataLocally() {
    String? localContent;
    String? lastSavedTimeString = _shredPreference.getString('dateTime');
    if (lastSavedTimeString != null) {
      DateTime lastSaved = DateTime.parse(lastSavedTimeString);

      if (DateTime.now().isAfter(lastSaved.add(const Duration(seconds: 15)))) {
        return null;
      } else {
        localContent = _shredPreference.getString('data');
      }
    }

    return localContent;
  }



  List<ClimateData> _parseClimateData(String fileContent) {
    List<ClimateData> dataList = [];
    List<String> lines = fileContent.split('\n');

    // Skip header lines (first 5 lines in this case)
    for (int i = 5; i < lines.length; i++) {
      String line = lines[i];
      if (line.trim().isEmpty) continue; // Skip empty lines

      List<String> parts = line.split(RegExp(r'\s+')); // Split by whitespace
      if (parts.length < 13) continue; // Ensure there are enough columns

      String year = parts[0];
      List<double> monthlyValues =
          parts.sublist(1, 13).map((v) => double.tryParse(v) ?? 0.0).toList();

      dataList.add(ClimateData( year,  monthlyValues));
    }

    return dataList;
  }



}
