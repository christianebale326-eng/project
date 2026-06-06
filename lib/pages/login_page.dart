import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/app_state.dart';
import '../data/nav.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    final wide = MediaQuery.of(context).size.width >= 860;

    final brand = Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(color: C.ink),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: C.amber, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.auto_awesome, color: C.ink, size: 20)),
              const SizedBox(width: 10),
              Text('CAPMATCH', style: display(size: 20, color: Colors.white)),
            ]),
            const SizedBox(height: 28),
            Text('Capstone, Thesis, Adviser & Chairman Matching System', style: display(size: 26, color: Colors.white)),
            const SizedBox(height: 14),
            const Text(
              'Intelligent adviser, panel, and chairman assignment powered by TF-IDF and cosine similarity — with automatic defense scheduling.',
              style: TextStyle(color: C.slate400, fontSize: 14, height: 1.6),
            ),
          ]),
          const Padding(
            padding: EdgeInsets.only(top: 28),
            child: Text('Agusan del Sur State University · College of Computing & Information Sciences',
                style: TextStyle(color: C.slate500, fontSize: 12)),
          ),
        ],
      ),
    );

    final login = Container(
      padding: const EdgeInsets.all(40),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Sign in', style: display(size: 24)),
          const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 22),
            child: Text('Select a role to explore the prototype.', style: TextStyle(color: C.slate400, fontSize: 14)),
          ),
          for (final r in roleOrder)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RoleButton(role: r, onTap: () => state.login(r)),
            ),
        ],
      ),
    );

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: wide
            ? IntrinsicHeight(
                child: Row(children: [
                  Expanded(child: brand),
                  Expanded(child: login),
                ]),
              )
            : Column(mainAxisSize: MainAxisSize.min, children: [brand, login]),
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight, radius: 1.2,
            colors: [Color(0xFFFDF4E3), C.bg],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Material(
              elevation: 18,
              borderRadius: BorderRadius.circular(24),
              shadowColor: const Color(0x33000000),
              child: card,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatefulWidget {
  final String role;
  final VoidCallback onTap;
  const _RoleButton({required this.role, required this.onTap});
  @override
  State<_RoleButton> createState() => _RoleButtonState();
}

class _RoleButtonState extends State<_RoleButton> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    final m = roleMeta[widget.role]!;
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFFFFBF2) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: hover ? const Color(0xFFFCD774) : C.border),
          ),
          child: Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: C.ink, borderRadius: BorderRadius.circular(12)), child: Icon(m.icon, color: C.amber, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.label, style: const TextStyle(fontWeight: FontWeight.w700, color: C.inkSoft, fontSize: 15)),
              Text(m.sub, style: const TextStyle(fontSize: 12, color: C.slate400)),
            ])),
            Icon(Icons.chevron_right, color: hover ? C.amber : C.slate400),
          ]),
        ),
      ),
    );
  }
}
