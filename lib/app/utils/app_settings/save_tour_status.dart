import 'package:shared_preferences/shared_preferences.dart';

class SaveTourStatus {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future saveReportsTourStatus(bool status) async {
    await _preferences?.setBool('reports_tour', status);
  }

  static Future<bool> getReportsTourStatus() async {
    return _preferences?.getBool('reports_tour') ?? false;
  }

  static Future saveInAppTourStatus(bool status) async {
    await _preferences?.setBool('tour', status);
  }

  static Future<bool> getInAppTourStatus() async {
    return _preferences?.getBool('tour') ?? false;
  }

  static Future saveFilterTourStatus(bool status) async {
    await _preferences?.setBool('filter_tour', status);
  }

  static Future<bool> getFilterTourStatus() async {
    return _preferences?.getBool('filter_tour') ?? false;
  }

  static Future saveProfileTourStatus(bool status) async {
    await _preferences?.setBool('profile_tour', status);
  }

  static Future<bool> getProfileTourStatus() async {
    return _preferences?.getBool('profile_tour') ?? false;
  }

  static Future saveDetailsTourStatus(bool status) async {
    await _preferences?.setBool('details_tour', status);
  }

  static Future<bool> getDetailsTourStatus() async {
    return _preferences?.getBool('details_tour') ?? false;
  }

  static Future saveManageTaskServerTourStatus(bool status) async {
    await _preferences?.setBool('manage_task_server_tour', status);
  }

  static Future<bool> getManageTaskServerTourStatus() async {
    return _preferences?.getBool('manage_task_server_tour') ?? false;
  }
}
