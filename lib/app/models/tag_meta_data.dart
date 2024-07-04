class TagMetadata {
  TagMetadata({
    required this.lastModified,
    required this.frequency,
    required this.selected,
  });

  final DateTime lastModified;
  final int frequency;
  final bool selected;

  Map toJson() => {
        'lastModified': lastModified,
        'frequency': frequency,
        'selected': selected,
      };

  @override
  String toString() => toJson().toString();
}
