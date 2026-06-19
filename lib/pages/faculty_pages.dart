import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/app_state.dart';
import '../models/faculty.dart';
import '../models/student.dart';
import '../utils/matching_engine.dart';
import '../widgets/app_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/indicators.dart';
import '../widgets/responsive_grid.dart';

class _Touch {
  final Student student;
  final String role;
  final double score;
  _Touch(this.student, this.role, this.score);
}

List<_Touch> _facultyTouches(AppState state, Faculty me) {
  final out = <_Touch>[];
  for (final s in state.students) {
    final a = autoAssign(s, state.faculty, state.threshold);
    if (a.adviser?.faculty.id == me.id) {
      out.add(_Touch(s, 'Adviser', a.adviser!.score));
    } else if (a.chairman?.faculty.id == me.id) {
      out.add(_Touch(s, 'Chairman', a.chairman!.score));
    } else {
      final p = a.panel.where((x) => x.faculty.id == me.id).toList();
      if (p.isNotEmpty) out.add(_Touch(s, 'Panelist', p.first.score));
    }
  }
  return out;
}

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final me = state.faculty.first;
    final touches = _facultyTouches(state, me);
    final asAdviser = touches.where((t) => t.role == 'Adviser').length;
    final asPanel = touches.where((t) => t.role != 'Adviser').length;
    final cols = MediaQuery.of(context).size.width >= 700 ? 4 : 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      PageTitle(title: 'Faculty Dashboard', subtitle: '${me.name} — ${me.specialization}'),
      ResponsiveGrid(columns: cols, children: [
        StatCard(icon: Icons.school_outlined, label: 'As Adviser', value: '$asAdviser', sub: 'max ${me.maxAdviserLoad}', delay: 0),
        StatCard(icon: Icons.groups_outlined, label: 'As Panelist', value: '$asPanel', sub: 'max ${me.maxPanelLoad}', tone: C.sky, toneBg: C.skySoft, delay: 60),
        StatCard(icon: Icons.speed_outlined, label: 'Adviser Load', value: '${((me.currentAdviserLoad / me.maxAdviserLoad) * 100).round()}%', tone: C.emerald, toneBg: C.emeraldSoft, delay: 120),
        const StatCard(icon: Icons.star_outline, label: 'Specialization', value: 'ML / DS', sub: 'Machine Learning', tone: C.orange, toneBg: C.orangeSoft, delay: 180),
      ]),
      const SizedBox(height: 20),
      AppCard(title: 'Incoming Assignments', icon: Icons.assignment_outlined, child: _AssignmentTable(touches: touches)),
    ]);
  }
}

class _AssignmentTable extends StatelessWidget {
  final List<_Touch> touches;
  const _AssignmentTable({required this.touches});
  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    if (touches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('No assignments yet.', style: TextStyle(color: C.slate400))),
      );
    }
    return Column(
      children: [
        for (final t in touches)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.slate50))),
            child: Row(children: [
              Expanded(
                flex: 3,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.student.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: C.slate700)),
                  Text(t.student.topic, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: C.slate400)),
                ]),
              ),
              const SizedBox(width: 8),
              Pill(t.role,
                  color: t.role == 'Adviser' ? C.amberDark : t.role == 'Chairman' ? C.emerald : C.sky,
                  bg: t.role == 'Adviser' ? C.amberSoft : t.role == 'Chairman' ? C.emeraldSoft : C.skySoft),
              const SizedBox(width: 10),
              SizedBox(width: 70, child: MatchScoreBar(score: t.score, showLabel: false)),
              const SizedBox(width: 6),
              TextButton.icon(
                onPressed: () => state.pushNotif('Assignment for ${t.student.name} declined — auto-reassigned to next best match.'),
                icon: const Icon(Icons.cancel_outlined, size: 14),
                label: const Text('Decline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                style: TextButton.styleFrom(foregroundColor: C.rose),
              ),
            ]),
          ),
      ],
    );
  }
}

class FacultyProfile extends StatefulWidget {
  const FacultyProfile({super.key});
  @override
  State<FacultyProfile> createState() => _FacultyProfileState();
}

class _FacultyProfileState extends State<FacultyProfile> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final me = state.faculty.first;
    final profile = AppCard(
      title: 'Research Profile',
      icon: Icons.manage_accounts_outlined,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        InfoRow('Name', me.name),
        InfoRow('Department', me.department),
        InfoRow('Specialization', me.specialization),
        const SizedBox(height: 12),
        const Text('Research Interests (matching keywords)', style: TextStyle(fontSize: 11, color: C.slate400)),
        const SizedBox(height: 6),
        KeywordChips(me.keywords),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: C.slate50, borderRadius: BorderRadius.circular(12)),
          child: Text(me.researchInterests, style: const TextStyle(fontSize: 12, color: C.slate400, height: 1.5)),
        ),
      ]),
    );

    final capacity = AppCard(
      title: 'Capacity Settings',
      icon: Icons.tune_outlined,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _slider('Maximum Adviser Load', me.maxAdviserLoad, me.currentAdviserLoad,
            (v) => state.setFacultyLoad(me.id, maxAdviser: v)),
        const SizedBox(height: 16),
        _slider('Maximum Panel Load', me.maxPanelLoad, me.currentPanelLoad,
            (v) => state.setFacultyLoad(me.id, maxPanel: v)),
        const SizedBox(height: 14),
        const Text('Capacity is enforced automatically — once full, the engine reassigns to the next best-matched faculty.',
            style: TextStyle(fontSize: 12, color: C.slate400)),
      ]),
    );

    final wide = MediaQuery.of(context).size.width >= 900;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'My Profile', subtitle: 'Manage research expertise and capacity used by the matching engine.'),
      wide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: profile), const SizedBox(width: 18), Expanded(child: capacity),
            ])
          : Column(children: [profile, const SizedBox(height: 18), capacity]),
    ]);
  }

  Widget _slider(String label, int value, int current, ValueChanged<int> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.slate500)),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w800, color: C.amberDark)),
      ]),
      Slider(
        value: value.toDouble(), min: 1, max: 8, divisions: 7,
        activeColor: C.amber, label: '$value',
        onChanged: (v) => onChanged(v.round()),
      ),
      Text('Currently used: $current / $value', style: const TextStyle(fontSize: 12, color: C.slate400)),
    ]);
  }
}

class FacultyAdvisees extends StatelessWidget {
  const FacultyAdvisees({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final me = state.faculty.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Advisees & Panels', subtitle: 'Students currently under your guidance and evaluation.'),
      AppCard(title: 'Current Assignments', icon: Icons.groups_outlined, child: _AssignmentTable(touches: _facultyTouches(state, me))),
    ]);
  }
}

class FacultyAssignments extends StatelessWidget {
  const FacultyAssignments({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final me = state.faculty.first;
    final touches = _facultyTouches(state, me);
    final adviserTouches = touches.where((t) => t.role == 'Adviser').toList();
    final panelTouches = touches.where((t) => t.role != 'Adviser').toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Assignments', subtitle: 'Roles the matching engine has assigned to you, by type.'),
      AppCard(
        title: 'As Adviser',
        icon: Icons.school_outlined,
        action: Pill('${adviserTouches.length}', color: C.amberDark, bg: C.amberSoft),
        child: adviserTouches.isEmpty
            ? const _EmptyState(
                icon: Icons.inbox_outlined,
                message: 'You have no advising assignments right now.',
              )
            : _AssignmentTable(touches: adviserTouches),
      ),
      const SizedBox(height: 18),
      AppCard(
        title: 'As Panel / Chairman',
        icon: Icons.groups_outlined,
        action: Pill('${panelTouches.length}', color: C.sky, bg: C.skySoft),
        child: panelTouches.isEmpty
            ? const _EmptyState(
                icon: Icons.inbox_outlined,
                message: 'You have no panel or chairman duties right now.',
              )
            : _AssignmentTable(touches: panelTouches),
      ),
    ]);
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(icon, size: 30, color: C.slate400),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: C.slate400, fontSize: 13)),
        ],
      ),
    );
  }
}
