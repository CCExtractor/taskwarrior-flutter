import 'package:shared_preferences/shared_preferences.dart';

class SaveFilterTour {
  Future<SharedPreferences> data = SharedPreferences.getInstance();

  void saveFilterTourStatus() async {
    final value = await data;
    value.setBool('filter_tour', true);
  }

  Future<bool> getFilterTourStatus() async {
    final value = await data;
    if (value.containsKey('filter_tour')) {
      bool? getData = value.getBool('filter_tour');
      return getData!;
    } else {
      return false;
    }
  }
}
