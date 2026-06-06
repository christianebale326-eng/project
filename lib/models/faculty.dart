class Faculty {
  final String id;
  final String name;
  final String title;
  final String department;
  final String specialization;
  final String researchInterests;
  final List<String> keywords;
  int maxAdviserLoad;
  int maxPanelLoad;
  int currentAdviserLoad;
  int currentPanelLoad;

  Faculty({
    required this.id,
    required this.name,
    required this.title,
    required this.department,
    required this.specialization,
    required this.researchInterests,
    required this.keywords,
    required this.maxAdviserLoad,
    required this.maxPanelLoad,
    required this.currentAdviserLoad,
    required this.currentPanelLoad,
  });

  /// The text "document" used by the TF-IDF matching engine.
  String get document => '$specialization $researchInterests ${keywords.join(' ')}';

  String get lastName => name.split(' ').last;
}
