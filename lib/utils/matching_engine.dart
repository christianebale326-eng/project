import 'dart:math';
import '../models/faculty.dart';
import '../models/student.dart';

const Set<String> _stopwords = {
  'a', 'an', 'and', 'the', 'of', 'for', 'to', 'in', 'on', 'with', 'using',
  'based', 'system', 'development', 'design', 'study', 'approach', 'framework',
  'application', 'via', 'through', 'into', 'from', 'that', 'this', 'these', 'it',
  'is', 'are', 'be', 'project', 'capstone', 'thesis', 'its', 'their', 'our',
  'toward', 'towards', 'within', 'across', 'also', 'by', 'as', 'at', 'or', 'not',
  'no', 'can', 'will', 'shall', 'use', 'used', 'uses',
};

/// Lowercase, strip punctuation, drop stopwords and tokens shorter than 3 chars.
List<String> tokenize(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .split(RegExp(r'\s+'))
      .where((t) => t.length > 2 && !_stopwords.contains(t))
      .toList();
}

/// Normalized term frequency for a token list.
Map<String, double> termFrequency(List<String> tokens) {
  final tf = <String, double>{};
  for (final t in tokens) {
    tf[t] = (tf[t] ?? 0) + 1;
  }
  final len = tokens.isEmpty ? 1 : tokens.length;
  tf.updateAll((k, v) => v / len);
  return tf;
}

/// Smoothed inverse document frequency over the document collection.
Map<String, double> computeIdf(List<List<String>> docs) {
  final n = docs.length;
  final df = <String, int>{};
  for (final tokens in docs) {
    for (final t in tokens.toSet()) {
      df[t] = (df[t] ?? 0) + 1;
    }
  }
  final idf = <String, double>{};
  df.forEach((t, c) => idf[t] = log((n + 1) / (c + 1)) + 1);
  return idf;
}

/// TF-IDF weighted vector for a token list, restricted to known vocabulary.
Map<String, double> tfidfVector(List<String> tokens, Map<String, double> idf) {
  final tf = termFrequency(tokens);
  final vec = <String, double>{};
  tf.forEach((t, v) {
    final w = idf[t];
    if (w != null) vec[t] = v * w;
  });
  return vec;
}

/// Cosine similarity between two sparse vectors. Returns 0..1.
double cosineSimilarity(Map<String, double> a, Map<String, double> b) {
  double dot = 0, na = 0, nb = 0;
  a.forEach((k, v) {
    final bv = b[k];
    if (bv != null) dot += v * bv;
  });
  for (final v in a.values) {
    na += v * v;
  }
  for (final v in b.values) {
    nb += v * v;
  }
  if (na == 0 || nb == 0) return 0;
  return dot / (sqrt(na) * sqrt(nb));
}

class RankedMatch {
  final Faculty faculty;
  final double score;
  final List<String> matchedKeywords;
  RankedMatch(this.faculty, this.score, this.matchedKeywords);
}

class Assignment {
  final String status; // 'assigned' | 'unmatched'
  final RankedMatch? adviser;
  final RankedMatch? chairman;
  final List<RankedMatch> panel;
  final List<RankedMatch> ranked;
  Assignment({
    required this.status,
    this.adviser,
    this.chairman,
    this.panel = const [],
    this.ranked = const [],
  });
}

/// Rank faculty by cosine similarity of their TF-IDF profile vs. the student query.
List<RankedMatch> rankFaculty(Student student, List<Faculty> facultyList) {
  final docTokens = facultyList.map((f) => tokenize(f.document)).toList();
  final idf = computeIdf(docTokens);
  final queryTokens = tokenize(student.document);
  final queryVec = tfidfVector(queryTokens, idf);
  final querySet = queryTokens.toSet();

  final results = <RankedMatch>[];
  for (var i = 0; i < facultyList.length; i++) {
    final fTokens = docTokens[i];
    final fVec = tfidfVector(fTokens, idf);
    final score = cosineSimilarity(queryVec, fVec);
    final matched = fTokens.toSet().where(querySet.contains).toList()
      ..sort((x, y) => (idf[y] ?? 0).compareTo(idf[x] ?? 0));
    results.add(RankedMatch(
      facultyList[i],
      score,
      matched.take(6).toList(),
    ));
  }
  results.sort((a, b) => b.score.compareTo(a.score));
  return results;
}

/// Auto-assign adviser (rank 1), chairman, and panel while enforcing capacity.
Assignment autoAssign(Student student, List<Faculty> facultyList, double threshold) {
  final ranked =
      rankFaculty(student, facultyList).where((r) => r.score >= threshold).toList();

  final eligibleAdviser = ranked
      .where((r) => r.faculty.currentAdviserLoad < r.faculty.maxAdviserLoad)
      .toList();
  if (eligibleAdviser.isEmpty) {
    return Assignment(status: 'unmatched', ranked: ranked);
  }

  final adviser = eligibleAdviser.first;
  final rest = ranked.where((r) => r.faculty.id != adviser.faculty.id).toList();
  final panelPool = rest
      .where((r) => r.faculty.currentPanelLoad < r.faculty.maxPanelLoad)
      .toList();

  final chairman = panelPool.isNotEmpty ? panelPool.first : null;
  final panel = panelPool.length > 1
      ? panelPool.sublist(1, panelPool.length >= 3 ? 3 : panelPool.length)
      : <RankedMatch>[];

  return Assignment(
    status: 'assigned',
    adviser: adviser,
    chairman: chairman,
    panel: panel,
    ranked: ranked,
  );
}

const List<String> defenseSlots = [
  'June 16, 2026 — 9:00 AM',
  'June 16, 2026 — 1:00 PM',
  'June 17, 2026 — 9:00 AM',
  'June 17, 2026 — 1:00 PM',
  'June 18, 2026 — 9:00 AM',
  'June 18, 2026 — 1:00 PM',
];
