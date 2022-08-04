import 'package:taskwarrior/widgets/taskserver.dart';

class Server {
  const Server({
    required this.address,
    required this.port,
  });

  factory Server.fromString(String server) {
    var split = server.split(':');
    if (split.length != 2) {
      throw TaskrcException(
        'Ensure your TASKRC\'s taskd.server contains one colon (:).',
      );
    }
    var address = split[0];
    var port = int.tryParse(split[1]);

    if (port == null) {
      throw TaskrcException(
          'Ensure your TASKRC\'s taskd.server has the form <domain>:<port>, '
          'where port is an integer.');
    }

    return Server(
      address: address,
      port: port,
    );
  }

  final String address;
  final int port;

  @override
  String toString() {
    return '$address:$port';
  }
}
