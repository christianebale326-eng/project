class Student {
  final String id;
  final String name;
  final String program;
  final String year;
  final String topic;
  final String researchArea;
  final String methodology;
  final List<String> keywords;
  bool submitted;

  Student({
    required this.id,
    required this.name,
    required this.program,
    required this.year,
    required this.topic,
    required this.researchArea,
    required this.methodology,
    required this.keywords,
    this.submitted = false,
  });

  /// The text "query document" built from the Capstone Request Form.
  String get document => '$topic $researchArea ${keywords.join(' ')} $methodology';
}
