import 'package:farm_setu_demo/core/models/APIResponse.dart';
import 'package:farm_setu_demo/services/apis.dart';

abstract class ClimateDataFromServer {
  Future<APIResponse<String>> getClimateDataByCountryURL(String countryURL);
}

class ClimateDataFromServerImpl implements ClimateDataFromServer {
  final APIs apis = APIs();

  @override
  Future<APIResponse<String>> getClimateDataByCountryURL(
      String countryURL) async {
    try {
      return APIResponse(data: await apis.downloadFile(countryURL));
    } catch (e) {
      return APIResponse(error: e.toString());
    }
  }
}
