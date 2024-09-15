import 'package:farm_setu_demo/core/models/APIResponse.dart';
import 'package:farm_setu_demo/core/utils/preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';



abstract class ClimateDataFromLocal {
  Future<APIResponse<String>> getClimateDataByCountryURL();
  Future<void> saveClimateDataByCountry(String climateDetails);
}

class ClimateDataFromLocalImpl implements ClimateDataFromLocal {


  @override
  Future<APIResponse<String>> getClimateDataByCountryURL() async{
final sharedPreferences = await SharedPreferences.getInstance();
    final data = sharedPreferences.getString(SharedPreferencesKeys.climateData);

    return data != null
        ? APIResponse(data: data)
        : APIResponse(error: 'No data found');
  }

  @override
  Future<void> saveClimateDataByCountry(String climateDetails) async{
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferencesKeys.climateData, climateDetails);
  }
}
