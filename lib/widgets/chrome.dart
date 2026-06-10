import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/app_state.dart';
import '../data/nav.dart';

class AppSidebar extends StatelessWidget {
  final VoidCallback? onTapItem;
  const AppSidebar({super.key, this.onTapItem});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = navFor[state.role]!;
    return Container(
      width: 264,
      color: C.ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: C.amber, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.auto_awesome, size: 19, color: C.ink),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CAPMATCH', style: display(size: 18, color: Colors.white)),
                    const Text('TF-IDF · COSINE SIMILARITY',
                        style: TextStyle(fontSize: 9, color: C.slate500, letterSpacing: 1.2)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final it = items[i];
                final selected = state.navIndex == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      state.setNav(i);
                      onTapItem?.call();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                      decoration: BoxDecoration(
                        color: selected ? C.amber : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(it.icon, size: 18, color: selected ? C.ink : C.slate400),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(it.label,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? C.ink : C.slate400)),
                          ),
                          if (selected) const Icon(Icons.chevron_right, size: 16, color: C.ink),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'Agusan del Sur State University\nCapstone Matching · 2026',
              style: TextStyle(fontSize: 11, color: C.slate500, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  final bool showMenu;
  final VoidCallback? onMenu;
  const TopBar({super.key, this.showMenu = false, this.onMenu});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final meta = roleMeta[state.role]!;
    final name = state.currentUser?.name ?? meta.name;
    final wide = MediaQuery.of(context).size.width >= 760;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: C.slate100)),
      ),
      child: Row(
        children: [
          if (widget.showMenu)
            IconButton(onPressed: widget.onMenu, icon: const Icon(Icons.menu, color: C.slate700)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome back,', style: TextStyle(fontSize: 12, color: C.slate400)),
              Text(name, style: display(size: 16)),
            ],
          ),
          const Spacer(),
          if (wide) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: C.slate100, borderRadius: BorderRadius.circular(99)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(meta.icon, size: 14, color: C.inkSoft),
                  const SizedBox(width: 5),
                  Text(meta.label,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: C.inkSoft)),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
          _notifications(state),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => state.logout(),
            icon: const Icon(Icons.logout, color: C.slate700, size: 20),
          ),
          const SizedBox(width: 4),
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: C.ink, borderRadius: BorderRadius.circular(11)),
            child: Icon(meta.icon, size: 18, color: C.amber),
          ),
        ],
      ),
    );
  }

  Widget _notifications(AppState state) {
    return PopupMenuButton<int>(
      tooltip: 'Notifications',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none, color: C.slate700),
          if (state.notifications.isNotEmpty)
            Positioned(
              right: -1, top: -1,
              child: Container(width: 8, height: 8,
                  decoration: const BoxDecoration(color: C.amber, shape: BoxShape.circle)),
            ),
        ],
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          enabled: false,
          child: Text('NOTIFICATIONS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: C.slate400)),
        ),
        for (final n in state.notifications)
          PopupMenuItem<int>(
            enabled: false,
            child: SizedBox(
              width: 240,
              child: Text(n, style: const TextStyle(fontSize: 13, color: C.slate700)),
            ),
          ),
      ],
    );
  }
}
