import 'package:shared_preferences/shared_preferences.dart';

class SaveInAppTour {
  Future<SharedPreferences> data = SharedPreferences.getInstance();

  void saveTourStatus() async {
    final value = await data;
    value.setBool('tour', true);
  }

  Future<bool> getTourStatus() async {
    final value = await data;
    if (value.containsKey('tour')) {
      bool? getData = value.getBool('tour');
      return getData!;
    } else {
      return false;
    }
  }
}
