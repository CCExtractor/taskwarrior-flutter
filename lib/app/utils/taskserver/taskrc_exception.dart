class TaskrcException implements Exception {
  TaskrcException(this.message);

  String message;

  @override
  String toString() => message;
}
