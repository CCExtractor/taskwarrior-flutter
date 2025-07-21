// Annotation class to mirror the Go Annotation struct
class Annotation {
  final String entry;
  final String description;

  Annotation({required this.entry, required this.description});

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      entry: json['entry'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entry': entry,
      'description': description,
    };
  }
}
