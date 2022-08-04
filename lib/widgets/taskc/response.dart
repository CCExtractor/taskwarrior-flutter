import 'package:taskwarrior/widgets/taskc/payload.dart';

class Response {
  Response({required this.header, required this.payload});

  factory Response.fromString(String string) {
    var firstPart = string.split('\n\n').first;
    var lastPart = string.split('\n\n').sublist(1).join('\n\n');
    var header = {
      for (var pair in firstPart.split('\n').map((line) => line.split(': ')))
        pair.first: pair.sublist(1).join(': '),
    };
    var payload = Payload.fromString(lastPart.trim());
    return Response(
      header: header,
      payload: payload,
    );
  }

  final Map header;
  final Payload payload;
}
