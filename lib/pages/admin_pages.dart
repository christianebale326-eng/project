import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../state/app_state.dart';
import '../utils/matching_engine.dart';
import '../widgets/app_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/indicators.dart';
import '../widgets/reveal.dart';
import '../widgets/responsive_grid.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    int assigned = 0;
    for (final s in state.students) {
      if (autoAssign(s, state.faculty, state.threshold).status == 'assigned') assigned++;
    }
    final unmatched = state.students.length - assigned;
    final cols = MediaQuery.of(context).size.width >= 700 ? 4 : 2;
    final wide = MediaQuery.of(context).size.width >= 900;

    final pie = AppCard(
      title: 'Assignment Status',
      icon: Icons.pie_chart_outline,
      child: SizedBox(
        height: 240,
        child: Row(children: [
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 52,
                sectionsSpace: 3,
                sections: [
                  PieChartSectionData(value: assigned.toDouble(), color: C.emerald, radius: 34, title: '$assigned', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  PieChartSectionData(value: unmatched.toDouble() == 0 ? 0.0001 : unmatched.toDouble(), color: C.orange, radius: 34, title: unmatched > 0 ? '$unmatched' : '', titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            _legend(C.emerald, 'Assigned'),
            const SizedBox(height: 8),
            _legend(C.orange, 'Unmatched'),
          ]),
          const SizedBox(width: 8),
        ]),
      ),
    );

    final facultyLoad = AppCard(
      title: 'Faculty by Adviser Load',
      icon: Icons.work_outline,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < state.faculty.length; i++)
          Reveal(
            delayMs: i * 50,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(state.faculty[i].name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: C.slate700)),
                  Text('${state.faculty[i].currentAdviserLoad}/${state.faculty[i].maxAdviserLoad}', style: const TextStyle(fontSize: 11, color: C.slate400)),
                ]),
                const SizedBox(height: 6),
                LayoutBuilder(builder: (context, cons) {
                  final frac = state.faculty[i].currentAdviserLoad / state.faculty[i].maxAdviserLoad;
                  return Container(
                    height: 8,
                    decoration: BoxDecoration(color: C.slate100, borderRadius: BorderRadius.circular(99)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(width: cons.maxWidth * frac, height: 8,
                          decoration: BoxDecoration(color: C.amber, borderRadius: BorderRadius.circular(99))),
                    ),
                  );
                }),
              ]),
            ),
          ),
      ]),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Administrator Dashboard', subtitle: 'System-wide statistics and configuration.'),
      ResponsiveGrid(columns: cols, children: [
        StatCard(icon: Icons.people_outline, label: 'Total Users', value: '${state.faculty.length + state.students.length + 2}', tone: C.sky, toneBg: C.skySoft, delay: 0),
        StatCard(icon: Icons.school_outlined, label: 'Students', value: '${state.students.length}', delay: 60),
        StatCard(icon: Icons.work_outline, label: 'Faculty', value: '${state.faculty.length}', tone: C.emerald, toneBg: C.emeraldSoft, delay: 120),
        StatCard(icon: Icons.tune_outlined, label: 'Threshold', value: state.threshold.toStringAsFixed(2), sub: 'min cosine', tone: C.orange, toneBg: C.orangeSoft, delay: 180),
      ]),
      const SizedBox(height: 20),
      wide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: pie), const SizedBox(width: 18), Expanded(child: facultyLoad),
            ])
          : Column(children: [pie, const SizedBox(height: 18), facultyLoad]),
    ]);
  }

  Widget _legend(Color color, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13, color: C.slate500)),
      ]);
}

class AdminUsers extends StatelessWidget {
  const AdminUsers({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final rows = <List<dynamic>>[
      for (final s in state.students) [s.name, 'Student', '${s.program} · ${s.year}', C.amberDark, C.amberSoft],
      for (final f in state.faculty) [f.name, 'Faculty', f.specialization, C.emerald, C.emeraldSoft],
      ['Prof. Jeanie Delos Arcos', 'Coordinator', 'Department Coordinator', C.sky, C.skySoft],
      ['System Admin', 'Administrator', 'IT Department', C.slate500, C.slate100],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'User Accounts', subtitle: 'Manage all registered users across roles.'),
      AppCard(
        title: 'All Accounts',
        icon: Icons.people_outline,
        child: Column(children: [
          for (final r in rows)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.slate50))),
              child: Row(children: [
                Expanded(flex: 2, child: Text(r[0] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: C.slate700))),
                Pill(r[1] as String, color: r[3] as Color, bg: r[4] as Color),
                const SizedBox(width: 12),
                Expanded(flex: 3, child: Text(r[2] as String, style: const TextStyle(fontSize: 12, color: C.slate500))),
                const Pill('Active', color: C.emerald, bg: C.emeraldSoft),
              ]),
            ),
        ]),
      ),
    ]);
  }
}

class AdminConfig extends StatelessWidget {
  const AdminConfig({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Matching Configuration', subtitle: 'Tune the parameters used by the TF-IDF + cosine similarity engine.'),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: AppCard(
          title: 'Engine Parameters',
          icon: Icons.tune_outlined,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Match Threshold (min cosine similarity)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.slate500)),
              Text(state.threshold.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w800, color: C.amberDark)),
            ]),
            Slider(value: state.threshold, min: 0, max: 0.5, divisions: 50, activeColor: C.amber, onChanged: state.setThreshold),
            const Text('Faculty below this score are not eligible for assignment.', style: TextStyle(fontSize: 12, color: C.slate400)),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Response Window (hours)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.slate500)),
              Text('${state.responseHours}h', style: const TextStyle(fontWeight: FontWeight.w800, color: C.amberDark)),
            ]),
            Slider(value: state.responseHours.toDouble(), min: 12, max: 96, divisions: 7, activeColor: C.amber, onChanged: (v) => state.setResponseHours(v.round())),
            const Text('Time a faculty has to respond before auto-reassignment.', style: TextStyle(fontSize: 12, color: C.slate400)),
          ]),
        ),
      ),
    ]);
  }
}

class AdminStats extends StatelessWidget {
  const AdminStats({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final data = state.faculty.map((f) {
      double sum = 0;
      for (final s in state.students) {
        final r = rankFaculty(s, state.faculty).firstWhere((x) => x.faculty.id == f.id);
        sum += r.score;
      }
      return [f.lastName, (sum / state.students.length * 100).round()];
    }).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'System Statistics', subtitle: 'Average match relevance per faculty across all student topics.'),
      AppCard(
        title: 'Average Match Score by Faculty',
        icon: Icons.insights_outlined,
        child: SizedBox(
          height: 320,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => const FlLine(color: C.slate100, strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= data.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(data[i][0] as String, style: const TextStyle(fontSize: 11, color: C.slate400)),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < data.length; i++)
                  BarChartGroupData(x: i, barRods: [
                    BarChartRodData(toY: (data[i][1] as int).toDouble(), color: C.amber, width: 18, borderRadius: const BorderRadius.vertical(top: Radius.circular(5))),
                  ]),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
