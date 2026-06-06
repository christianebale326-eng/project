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

class _Row {
  final String name, topic, adviser, status;
  final double score;
  _Row(this.name, this.topic, this.adviser, this.status, this.score);
}

List<_Row> _rows(AppState state) {
  return state.students.map((s) {
    final a = autoAssign(s, state.faculty, state.threshold);
    return _Row(
      s.name, s.topic,
      a.adviser?.faculty.name ?? '—',
      a.status == 'assigned' ? 'assigned' : 'unmatched',
      a.adviser?.score ?? 0,
    );
  }).toList();
}

class CoordinatorDashboard extends StatelessWidget {
  const CoordinatorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final rows = _rows(state);
    final assigned = rows.where((r) => r.status == 'assigned').length;
    final cols = MediaQuery.of(context).size.width >= 700 ? 4 : 2;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Coordinator Dashboard', subtitle: 'Department-wide matching oversight and intervention.'),
      ResponsiveGrid(columns: cols, children: [
        StatCard(icon: Icons.groups_outlined, label: 'Total Students', value: '${rows.length}', tone: C.sky, toneBg: C.skySoft, delay: 0),
        StatCard(icon: Icons.check_circle_outline, label: 'Auto-Assigned', value: '$assigned', tone: C.emerald, toneBg: C.emeraldSoft, delay: 60),
        StatCard(icon: Icons.error_outline, label: 'Unmatched', value: '${rows.length - assigned}', tone: C.orange, toneBg: C.orangeSoft, delay: 120),
        StatCard(icon: Icons.work_outline, label: 'Active Faculty', value: '${state.faculty.length}', delay: 180),
      ]),
      const SizedBox(height: 20),
      AppCard(title: 'Matching Monitor', icon: Icons.monitor_heart_outlined, child: _MonitorTable(rows: rows)),
    ]);
  }
}

class _MonitorTable extends StatelessWidget {
  final List<_Row> rows;
  const _MonitorTable({required this.rows});
  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Column(children: [
      for (final r in rows)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: C.slate50))),
          child: Row(children: [
            Expanded(
              flex: 3,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: C.slate700)),
                Text(r.topic, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: C.slate400)),
              ]),
            ),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: Text(r.adviser, style: const TextStyle(fontSize: 12, color: C.slate500))),
            SizedBox(width: 64, child: r.score > 0 ? MatchScoreBar(score: r.score, showLabel: false) : const Text('—', style: TextStyle(color: C.slate400))),
            const SizedBox(width: 10),
            StatusBadge(r.status),
            const SizedBox(width: 6),
            TextButton.icon(
              onPressed: () => state.pushNotif('Validated assignment for ${r.name}.'),
              icon: const Icon(Icons.check_circle_outline, size: 14),
              label: const Text('Validate', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              style: TextButton.styleFrom(foregroundColor: C.emerald),
            ),
          ]),
        ),
    ]);
  }
}

class CoordinatorMonitor extends StatelessWidget {
  const CoordinatorMonitor({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Matching Monitor', subtitle: 'Live status of every student in the department.'),
      AppCard(title: 'All Students', icon: Icons.monitor_heart_outlined, child: _MonitorTable(rows: _rows(state))),
    ]);
  }
}

class CoordinatorLoadBalance extends StatelessWidget {
  const CoordinatorLoadBalance({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final data = state.faculty.map((f) {
      int adv = 0, pan = 0;
      for (final s in state.students) {
        final a = autoAssign(s, state.faculty, state.threshold);
        if (a.adviser?.faculty.id == f.id) adv++;
        if (a.chairman?.faculty.id == f.id) pan++;
        if (a.panel.any((p) => p.faculty.id == f.id)) pan++;
      }
      return [f.lastName, adv, pan];
    }).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Load Balance', subtitle: 'Distribution of adviser and panel duties across faculty.'),
      AppCard(
        title: 'Faculty Workload Distribution',
        icon: Icons.bar_chart_outlined,
        child: SizedBox(
          height: 320,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => const FlLine(color: C.slate100, strokeWidth: 1)),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
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
                  BarChartGroupData(x: i, barsSpace: 4, barRods: [
                    BarChartRodData(toY: (data[i][1] as int).toDouble(), color: C.amber, width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                    BarChartRodData(toY: (data[i][2] as int).toDouble(), color: C.sky, width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                  ]),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        _Legend(color: C.amber, label: 'Adviser'),
        SizedBox(width: 18),
        _Legend(color: C.sky, label: 'Panel'),
      ]),
    ]);
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: C.slate500)),
    ]);
  }
}

class CoordinatorAudit extends StatelessWidget {
  const CoordinatorAudit({super.key});
  @override
  Widget build(BuildContext context) {
    const logs = [
      ['10:42 AM', 'Auto-assignment completed for Maria Lopez (Adviser: Dr. Marquez)'],
      ['10:39 AM', 'Capstone Request submitted by Patricia Gomez'],
      ['09:58 AM', 'Dr. Reyes declined panel duty for Angela Reyes — reassigned'],
      ['09:30 AM', 'Defense scheduled: June 16, 2026 9:00 AM'],
      ['08:15 AM', 'Faculty capacity updated — Engr. Santos (max adviser: 4)'],
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const PageTitle(title: 'Audit Logs', subtitle: 'Chronological record of system actions for accountability.'),
      AppCard(
        title: 'Recent Activity',
        icon: Icons.receipt_long_outlined,
        child: Column(children: [
          for (var i = 0; i < logs.length; i++)
            Reveal(
              delayMs: i * 50,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: i == logs.length - 1
                    ? null
                    : const BoxDecoration(border: Border(bottom: BorderSide(color: C.slate50))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 76, child: Text(logs[i][0], style: const TextStyle(fontSize: 12, color: C.slate400))),
                  Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 5, right: 10),
                      decoration: const BoxDecoration(color: C.amber, shape: BoxShape.circle)),
                  Expanded(child: Text(logs[i][1], style: const TextStyle(fontSize: 13, color: C.slate700))),
                ]),
              ),
            ),
        ]),
      ),
    ]);
  }
}
