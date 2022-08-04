import 'package:package_info_plus/package_info_plus.dart';

Future<String> client() async {
  var packageInfo = await PackageInfo.fromPlatform();
  return '${packageInfo.packageName} ${packageInfo.version}';
}
