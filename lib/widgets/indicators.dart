import 'package:flutter/material.dart';
import '../theme.dart';

class MatchScoreBar extends StatelessWidget {
  final double score;
  final bool showLabel;
  const MatchScoreBar({super.key, required this.score, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).clamp(0, 100).round();
    final color = toneColor(score);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment:
              showLabel ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
          children: [
            if (showLabel)
              const Text('match',
                  style: TextStyle(fontSize: 11, color: C.slate400, fontWeight: FontWeight.w500)),
            Text('$pct%',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 5),
        LayoutBuilder(
          builder: (context, cons) {
            return Container(
              height: 8,
              decoration: BoxDecoration(
                color: C.slate100,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: pct / 100),
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, __) => Container(
                    height: 8,
                    width: cons.maxWidth * v,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  const Pill(this.label, {super.key, this.color = C.slate500, this.bg = C.slate100});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    late Color color, bg;
    late String label;
    switch (status) {
      case 'assigned':
        icon = Icons.check_circle_outline; color = C.emerald; bg = C.emeraldSoft; label = 'Assigned';
        break;
      case 'declined':
        icon = Icons.cancel_outlined; color = C.rose; bg = C.roseSoft; label = 'Declined';
        break;
      case 'reassigned':
        icon = Icons.refresh; color = C.amberDark; bg = C.amberSoft; label = 'Reassigned';
        break;
      case 'unmatched':
        icon = Icons.error_outline; color = C.orange; bg = C.orangeSoft; label = 'Unmatched';
        break;
      default:
        icon = Icons.schedule; color = C.sky; bg = C.skySoft; label = 'Pending';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class KeywordChips extends StatelessWidget {
  final List<String> words;
  final Color color;
  final Color bg;
  const KeywordChips(this.words, {super.key, this.color = C.amberDark, this.bg = C.amberSoft});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final w in words)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(7)),
            child: Text(w, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ),
      ],
    );
  }
}
