import 'package:flutter/material.dart';
import '../theme.dart';
import 'reveal.dart';

class AppCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final Widget? action;
  const AppCard({super.key, this.title, this.icon, required this.child, this.action});

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: C.slate100),
          boxShadow: const [
            BoxShadow(color: Color(0x0A0F172A), blurRadius: 18, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: C.amber),
                      const SizedBox(width: 8),
                    ],
                    Expanded(child: Text(title!, style: display(size: 17))),
                    if (action != null) action!,
                  ],
                ),
              ),
            if (title != null) const Divider(height: 1, color: C.slate50),
            Padding(padding: const EdgeInsets.all(20), child: child),
          ],
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const PageTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: display(size: 28)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(subtitle!, style: const TextStyle(color: C.slate400, fontSize: 14)),
              ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String k;
  final String v;
  const InfoRow(this.k, this.v, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: const TextStyle(color: C.slate400, fontSize: 13)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(v,
                textAlign: TextAlign.right,
                style: const TextStyle(color: C.slate700, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class Field extends StatelessWidget {
  final String label;
  final Widget child;
  const Field({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.slate500)),
        ),
        child,
      ],
    );
  }
}

InputDecoration capInput(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: C.slate400, fontSize: 13),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: C.amber, width: 1.5),
      ),
    );
