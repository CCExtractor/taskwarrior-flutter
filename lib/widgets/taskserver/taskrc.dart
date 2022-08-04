import 'package:taskwarrior/widgets/taskserver.dart';

class Taskrc {
  Taskrc({
    this.server,
    this.credentials,
    // ignore: always_put_required_named_parameters_first
    required this.pemFilePaths,
  });

  factory Taskrc.fromString(String taskrc) {
    return Taskrc.fromMap(
      parseTaskrc(taskrc),
    );
  }

  factory Taskrc.fromMap(Map taskrc) {
    var server = taskrc['taskd.server'];
    var credentials = taskrc['taskd.credentials'];
    return Taskrc(
      server: (server == null) ? null : Server.fromString(server),
      credentials:
          (credentials == null) ? null : Credentials.fromString(credentials),
      pemFilePaths: PemFilePaths.fromTaskrc(taskrc),
    );
  }

  final Server? server;
  final Credentials? credentials;
  final PemFilePaths pemFilePaths;
}
