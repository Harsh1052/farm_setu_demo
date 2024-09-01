import 'package:farm_setu_demo/services/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/climate.dart';
import '../models/climate_table_format.dart';

class WeatherProvider extends ChangeNotifier {
  List<ClimateData> _climateData = [];
  List<ClimateTableData> _climateTableData = [];
  List<ClimateTableData> _climateTableDataScotland = [];
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
  List<ClimateTableData> get climateTableData => _climateTableData;
  List<ClimateTableData> get climateTableDataScotland =>
      _climateTableDataScotland;

  loadClimateData() async {
    final fileContent = await downloadFile(
        'https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/UK.txt');
    _climateData = _parseClimateData(fileContent);

    notifyListeners();
  }

  loadClimateDataForTableForUK() async {
    final fileContent = await downloadFile(
        'https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/UK.txt');
    _climateTableData = _parseClimateTableData(fileContent);

    selectedYear = _climateTableData.last.year;
    addPolygons('UK');

    notifyListeners();
  }

  loadClimateDataForTableScotland() async {
    final fileContent = await downloadFile(
        'https://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/Tmax/date/Scotland_N.txt');
    _climateTableDataScotland = _parseClimateTableData(fileContent);

    selectedYear = _climateTableDataScotland.last.year;
    addPolygons('Scotland');

    notifyListeners();
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

      dataList.add(ClimateData(year, monthlyValues));
    }

    return dataList;
  }

  List<ClimateTableData> _parseClimateTableData(String fileContent) {
    List<ClimateTableData> climateDataList = [];
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
          .add(ClimateTableData(year: year, monthlyValues: monthlyValues));
    }

    return climateDataList;
  }

  void addPolygons(String region) {


    //polygons.clear();
    if (region == 'Scotland') {
      final avegTemp = climateTableDataScotland.where((e)=> e.year==selectedYear).first.monthlyValues.reduce((a, b) => a + b) / climateTableDataScotland.last.monthlyValues.length;
      _polygons.add(
        Polygon(
          polygonId: PolygonId('Scotland'),
          points: _getScotlandPolygonPoints(),
          strokeColor: Colors.black,
          strokeWidth: 0,
          fillColor: _getColorForTemperature(avegTemp),
        ),
      );
    } else {
      final avegTemp = climateTableData.where((e)=> e.year==selectedYear).first.monthlyValues.reduce((a, b) => a + b) / climateTableData.last.monthlyValues.length;

      _polygons.add(
        Polygon(
          polygonId: PolygonId('UK'),
          points: _getNIrelandPolygonPoints(),
          strokeColor: Colors.black,
          strokeWidth: 0,
          fillColor: _getColorForTemperature(avegTemp),
        ),
      );
    }

    // Repeat for other regions...

    notifyListeners();
  }

  updatePolygons() {
    polygons.clear();
    addPolygons('UK');
    addPolygons('Scotland');
  }

  Color _getColorForTemperature(double temperature) {
    if (temperature <= 11.0) {
      return Colors.blue.withOpacity(0.7);
    } else if (temperature <= 12.0) {
      return Colors.green.withOpacity(0.7);
    } else if (temperature <= 13.0) {
      return Colors.yellow.withOpacity(0.7);
    } else {
      return Colors.red.withOpacity(0.7);
    }
  }

  List<LatLng> _getScotlandPolygonPoints() {
    // Example coordinates, replace with actual boundary points
    return [
      LatLng(54.9518316181954, -3.195210127112148),
      LatLng(55.38854570282086, -2.3196022928474065),
      LatLng(55.4851996976505, -2.143524756836399),
      LatLng(55.6166699131214, -2.262073074737259),
      LatLng(55.81790199334165, -1.999769298204427),
      LatLng(56.051463711135, -2.6454615052886084),
      LatLng(55.94959946355311, -3.3616195164376848),
      LatLng(56.021720902600066, -3.7051735483354094),
      LatLng(56.03480014484768, -3.2769197336843376),
      LatLng(56.21877568808469, -2.9769997061133324),
      LatLng(56.23740227273453, -2.6422196040299752),
      LatLng(56.386188736258106, -2.8987224438575367),
      LatLng(56.36540384660944, -3.2915002550792565),
      LatLng(56.505120710888065, -2.6837715283231773),
      LatLng(57.129057906410026, -2.032584113142775),
      LatLng(57.25306073181818, -2.0608412795854747),
      LatLng(57.44446077592838, -1.7863447819146074),
      LatLng(57.70293152150256, -1.9010802315000035),
      LatLng(57.690789578158586, -3.0679455699884386),
      LatLng(57.75212151783637, -3.333846676415959),
      LatLng(57.46283808465395, -4.255408346078696),
      LatLng(57.614550915297144, -4.101306847633651),
      LatLng(57.80052703621433, -3.8523956148905825),
      LatLng(57.88565807218845, -4.162075801366683),
      LatLng(58.28788450543897, -3.3434662855249258),
      LatLng(58.398885648124775, -3.117799973220599),
      LatLng(58.50378853742376, -3.1511568199052533),
      LatLng(58.61118031435001, -3.0843426733861747),
      LatLng(58.63173993821218, -3.5515986057456814),
      LatLng(58.499084445241124, -4.483292157280488),
      LatLng(58.512067967241165, -4.458948555758866),
      LatLng(58.608862359693774, -4.961518839514611),
      LatLng(58.27503948153759, -5.3226864582949815),
      LatLng(57.89920057679012, -5.235622204771687),
      LatLng(57.87457114529093, -5.76682016785557),
      LatLng(57.28266496616433, -5.605067332731778),
      LatLng(57.34790078007262, -6.090230030171796),
      LatLng(57.644807642420375, -6.126794646369518),
      LatLng(57.535661578014015, -6.764939827547778),
      LatLng(57.184656468499725, -6.380680655127293),
      LatLng(57.01899862846835, -5.83785858925927),
      LatLng(56.33306282594151, -6.439343570597941),
      LatLng(56.286951001719785, -5.829739943845425),
      LatLng(55.71394857011768, -6.5500901546051296),
      LatLng(55.550274185129524, -6.074836985317177),
      LatLng(55.84079741357914, -5.761682036961673),
      LatLng(55.27681361796718, -5.820963727745209),
      LatLng(55.36276052361268, -5.4901169928628235),
      LatLng(55.50134367865499, -5.049548094641864),
      LatLng(55.468625382388666, -4.798698873230421),
      LatLng(54.98779991666501, -5.19002894380958),
      LatLng(54.66278096848711, -4.922081220851766),
      LatLng(54.95811440994129, -3.187187376349925),
      LatLng(54.9518316181954, -3.195210127112148),

    ];
  }

  List<LatLng> _getNIrelandPolygonPoints() {
    // Example coordinates, replace with actual boundary points for N. Ireland
    return [
      LatLng(51.768945055076784, -2.3634073002175455),
      LatLng(52.889460475200735, 0.044658893676853495),
      LatLng(53.14997037753355, 0.37866181878064253),
      LatLng(53.4802265549873, 0.13784066137264972),
      LatLng(53.709990555027076, -0.2829454225655468),
      LatLng(53.75350477134225, -0.5919530383248457),
      LatLng(53.812243816062505, -0.2620809673954909),
      LatLng(53.63340843066351, 0.16202063653531695),
      LatLng(54.02681554986805, -0.16737199098199085),
      LatLng(54.17955285839864, -0.02159558712722287),
      LatLng(54.67178979077153, -1.248095701472181),
      LatLng(55.72451757329577, -1.7935356965609799),
      LatLng(54.924625623097825, -3.1870975742755547),
      LatLng(54.47918860396729, -3.642968864207404),
      LatLng(54.067212040208545, -3.2366029437262114),
      LatLng(54.16244313917426, -2.8123128793315004),
      LatLng(53.79253427226163, -3.0350709375776432),
      LatLng(53.40189625154238, -3.1006299192746667),
      LatLng(52.99276207173958, -2.7122758852183892),
      LatLng(52.922092263889425, -3.0495336407467164),
      LatLng(52.35294009030895, -2.997716154718887),
      LatLng(52.07907002678354, -3.138555737929778),
      LatLng(51.8327911799941, -2.6556982073340976),
      LatLng(51.60548564692971, -2.7615183694497887),
      LatLng(51.768945055076784, -2.3634073002175455),

    ];
  }
}
