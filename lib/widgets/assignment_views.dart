import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/matching_engine.dart';
import 'app_card.dart';
import 'indicators.dart';

class PersonRow extends StatelessWidget {
  final String role;
  final RankedMatch data;
  final bool highlight;
  const PersonRow({super.key, required this.role, required this.data, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: highlight
          ? null
          : const BoxDecoration(border: Border(top: BorderSide(color: C.slate50))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: highlight ? C.amber : C.slate100,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: Text(
              data.faculty.lastName.substring(0, 1),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: highlight ? C.ink : C.slate500),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(data.faculty.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: C.inkSoft)),
                    ),
                    const SizedBox(width: 8),
                    Pill(role,
                        color: highlight ? C.amberDark : C.slate500,
                        bg: highlight ? C.amberSoft : C.slate100),
                  ],
                ),
                Text(data.faculty.specialization,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: C.slate400)),
                if (data.matchedKeywords.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  KeywordChips(data.matchedKeywords, color: C.emerald, bg: C.emeraldSoft),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 90, child: MatchScoreBar(score: data.score, showLabel: false)),
        ],
      ),
    );
  }
}

class AssignmentResult extends StatelessWidget {
  final Assignment assignment;
  const AssignmentResult({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    if (assignment.status == 'unmatched') {
      return const AppCard(
        title: 'Your Automatic Assignment',
        icon: Icons.workspace_premium_outlined,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: C.orange, size: 32),
              SizedBox(height: 8),
              Text('No match above threshold — coordinator intervention required.',
                  textAlign: TextAlign.center, style: TextStyle(color: C.slate500)),
            ],
          ),
        ),
      );
    }
    return AppCard(
      title: 'Your Automatic Assignment',
      icon: Icons.workspace_premium_outlined,
      action: const StatusBadge('assigned'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (assignment.adviser != null)
            PersonRow(role: 'Adviser', data: assignment.adviser!, highlight: true),
          if (assignment.chairman != null)
            PersonRow(role: 'Chairman', data: assignment.chairman!),
          for (var i = 0; i < assignment.panel.length; i++)
            PersonRow(role: 'Panelist ${i + 1}', data: assignment.panel[i]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: C.amberSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFCE7AE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.event, size: 16, color: C.amberDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Defense scheduled — ${defenseSlots.first}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: C.amberDark)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
