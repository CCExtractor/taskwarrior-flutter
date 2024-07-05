import 'package:shared_preferences/shared_preferences.dart';

class SaveReportsTour {
  Future<SharedPreferences> data = SharedPreferences.getInstance();

  void saveReportsTourStatus() async {
    final value = await data;
    value.setBool('reports_tour', true);
  }

  Future<bool> getReportsTourStatus() async {
    final value = await data;
    if (value.containsKey('reports_tour')) {
      bool? getData = value.getBool('reports_tour');
      return getData!;
    } else {
      return false;
    }
  }
}
