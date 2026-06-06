import 'package:flutter/material.dart';
import '../theme.dart';
import 'reveal.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  final Color tone;
  final Color toneBg;
  final int delay;
  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.sub,
    this.tone = C.amberDark,
    this.toneBg = C.amberSoft,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delayMs: delay,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: C.slate100),
          boxShadow: const [
            BoxShadow(color: Color(0x080F172A), blurRadius: 14, offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 13, color: C.slate400, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(value, style: display(size: 26)),
                  if (sub != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(sub!, style: const TextStyle(fontSize: 11, color: C.slate400)),
                    ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: toneBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: tone),
            ),
          ],
        ),
      ),
    );
  }
}
