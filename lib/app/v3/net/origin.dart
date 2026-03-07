import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

Future<String> getOrigin() async => await CredentialsStorage.getApiUrl() ?? '';
