part of 'app_settings.dart';

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

  static Future saveTaskSwipeTutorialStatus(bool status) async {
    await _preferences?.setBool('task_swipe_tutorial_completed', status);
  }

  static Future<bool> getTaskSwipeTutorialStatus() async {
    return _preferences?.getBool('task_swipe_tutorial_completed') ?? false;
  }

  static Future saveTutorialPromptShown(bool status) async {
    await _preferences?.setBool('tutorial_prompt_shown', status);
  }

  static Future<bool> getTutorialPromptShown() async {
    return _preferences?.getBool('tutorial_prompt_shown') ?? false;
  }
}
