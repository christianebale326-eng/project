import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/app_state.dart';
import '../models/student.dart';
import '../utils/matching_engine.dart';
import '../widgets/app_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/indicators.dart';
import '../widgets/assignment_views.dart';
import '../widgets/responsive_grid.dart';

bool _wide(BuildContext c) => MediaQuery.of(c).size.width >= 900;

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final student = state.students.first;
    final a = autoAssign(student, state.faculty, state.threshold);
    final cols = MediaQuery.of(context).size.width >= 700 ? 4 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageTitle(title: 'Student Dashboard', subtitle: 'Track your capstone adviser, panel, and defense at a glance.'),
        ResponsiveGrid(columns: cols, children: [
          StatCard(icon: Icons.description_outlined, label: 'Request Status', value: 'Submitted', tone: C.emerald, toneBg: C.emeraldSoft, delay: 0),
          StatCard(icon: Icons.workspace_premium_outlined, label: 'Adviser Match', value: a.adviser != null ? '${(a.adviser!.score * 100).round()}%' : '—', delay: 60),
          StatCard(icon: Icons.groups_outlined, label: 'Panel Members', value: '${a.panel.length + 1}', sub: 'incl. chairman', tone: C.sky, toneBg: C.skySoft, delay: 120),
          StatCard(icon: Icons.event_outlined, label: 'Defense', value: 'Jun 16', sub: '9:00 AM', tone: C.emerald, toneBg: C.emeraldSoft, delay: 180),
        ]),
        const SizedBox(height: 20),
        _wide(context)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: AssignmentResult(assignment: a)),
                  const SizedBox(width: 18),
                  Expanded(child: _submissionCard(student)),
                ],
              )
            : Column(children: [
                AssignmentResult(assignment: a),
                const SizedBox(height: 18),
                _submissionCard(student),
              ]),
      ],
    );
  }

  Widget _submissionCard(Student s) => AppCard(
        title: 'Your Submission',
        icon: Icons.description_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.topic, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: C.slate700, height: 1.4)),
            const SizedBox(height: 12),
            InfoRow('Research Area', s.researchArea),
            InfoRow('Methodology', s.methodology),
            const SizedBox(height: 12),
            const Text('Keywords', style: TextStyle(fontSize: 11, color: C.slate400)),
            const SizedBox(height: 6),
            KeywordChips(s.keywords),
          ],
        ),
      );
}

class CapstoneRequestForm extends StatefulWidget {
  const CapstoneRequestForm({super.key});
  @override
  State<CapstoneRequestForm> createState() => _CapstoneRequestFormState();
}

class _CapstoneRequestFormState extends State<CapstoneRequestForm> {
  final topic = TextEditingController();
  final area = TextEditingController();
  final method = TextEditingController();
  final keywords = TextEditingController();
  Assignment? result;

  @override
  void dispose() {
    topic.dispose(); area.dispose(); method.dispose(); keywords.dispose();
    super.dispose();
  }

  void _submit(AppState state) {
    final s = Student(
      id: 'temp', name: 'You', program: 'BSIT', year: '4th Year',
      topic: topic.text, researchArea: area.text, methodology: method.text,
      keywords: keywords.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    );
    setState(() => result = autoAssign(s, state.faculty, state.threshold));
    state.pushNotif('Capstone Request submitted — adviser, panel & chairman auto-assigned.');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final form = AppCard(
      title: 'Request Details',
      icon: Icons.description_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Field(label: 'Proposed Thesis / Capstone Topic', child: TextField(controller: topic, maxLines: 3, decoration: capInput('e.g. An Intelligent Crop Disease Detection System Using CNN...'))),
          const SizedBox(height: 14),
          Field(label: 'Research Area', child: TextField(controller: area, decoration: capInput('e.g. Machine Learning'))),
          const SizedBox(height: 14),
          Field(label: 'Methodology', child: TextField(controller: method, decoration: capInput('e.g. Experimental / Developmental'))),
          const SizedBox(height: 14),
          Field(label: 'Keywords (comma-separated)', child: TextField(controller: keywords, decoration: capInput('deep learning, neural networks, classification'))),
          const SizedBox(height: 18),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => _submit(state),
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Submit & Auto-Assign', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: C.ink, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );

    final ranking = AppCard(
      title: 'Live Match Ranking',
      icon: Icons.auto_awesome,
      child: result == null
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Column(children: [
                Icon(Icons.search, color: C.slate400, size: 28),
                SizedBox(height: 10),
                Text('Submit the form to compute live match scores.',
                    textAlign: TextAlign.center, style: TextStyle(color: C.slate400, fontSize: 13)),
              ]),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < result!.ranked.take(6).length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.w800, color: C.slate400)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(result!.ranked[i].faculty.name,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: C.slate700)),
                          ),
                          if (i == 0) const Pill('Adviser', color: C.amberDark, bg: C.amberSoft),
                        ]),
                        const SizedBox(height: 6),
                        MatchScoreBar(score: result!.ranked[i].score, showLabel: false),
                        if (result!.ranked[i].matchedKeywords.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          KeywordChips(result!.ranked[i].matchedKeywords, color: C.emerald, bg: C.emeraldSoft),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageTitle(title: 'Capstone Request Form', subtitle: 'Submit your topic — the engine computes TF-IDF + cosine similarity and assigns automatically.'),
        _wide(context)
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: form),
                const SizedBox(width: 18),
                Expanded(child: ranking),
              ])
            : Column(children: [form, const SizedBox(height: 18), ranking]),
      ],
    );
  }
}

class StudentAssignment extends StatelessWidget {
  const StudentAssignment({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final a = autoAssign(state.students.first, state.faculty, state.threshold);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'My Assignment', subtitle: 'Your adviser, chairman, and panel with computed match scores.'),
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: AssignmentResult(assignment: a)),
    ]);
  }
}

class StudentSchedule extends StatelessWidget {
  const StudentSchedule({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Defense Schedule', subtitle: 'Your auto-scheduled capstone defense session.'),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: AppCard(
          title: 'Scheduled Defense',
          icon: Icons.event_outlined,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [C.amberSoft, Color(0xFFFFE8CC)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFCE7AE)),
              ),
              child: Row(children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: C.amber, borderRadius: BorderRadius.circular(16)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('JUN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: C.ink)),
                    Text('16', style: display(size: 24, color: C.ink)),
                  ]),
                ),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Capstone Defense', style: display(size: 18)),
                  const Text('Monday, June 16, 2026 · 9:00 AM', style: TextStyle(fontSize: 13, color: C.slate500)),
                  const Text('Room: CCIS Conference Hall', style: TextStyle(fontSize: 13, color: C.slate500)),
                ]),
              ]),
            ),
            const SizedBox(height: 14),
            const Text('Notification order: Adviser → Panel → Chairman → Student, each with a 48-hour response window.',
                style: TextStyle(fontSize: 12, color: C.slate400)),
          ]),
        ),
      ),
    ]);
  }
}
