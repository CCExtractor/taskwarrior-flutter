import 'package:taskwarrior/widgets/taskserver.dart';

String message({
  String? client,
  // ignore: always_put_required_named_parameters_first
  required String type,
  Credentials? credentials,
  String? payload,
}) {
  return '''
${(client != null) ? 'client: $client\n' : ''}type: $type
org: ${credentials?.org ?? ''}
user: ${credentials?.user ?? ''}
key: ${credentials?.key ?? ''}
protocol: v1

$payload''';
}
