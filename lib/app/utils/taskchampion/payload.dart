class Payload {
  Payload({required this.tasks, this.userKey});

  factory Payload.fromString(String string) {
    var lines = string.trim().split('\n');
    var userKey = lines.removeLast();
    return Payload(
      tasks: lines,
      userKey: userKey,
    );
  }

  final List<String> tasks;
  final String? userKey;

  @override
  String toString() => tasks.followedBy([userKey ?? '']).join('\n').trim();
}
