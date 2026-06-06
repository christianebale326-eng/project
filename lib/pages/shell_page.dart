import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/chrome.dart';
import 'student_pages.dart';
import 'faculty_pages.dart';
import 'coordinator_pages.dart';
import 'admin_pages.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  Widget _body(String role, int index) {
    switch (role) {
      case 'student':
        return [const StudentDashboard(), const CapstoneRequestForm(), const StudentAssignment(), const StudentSchedule()][index];
      case 'faculty':
        return [const FacultyDashboard(), const FacultyProfile(), const FacultyDashboard(), const FacultyAdvisees()][index];
      case 'coordinator':
        return [const CoordinatorDashboard(), const CoordinatorMonitor(), const CoordinatorLoadBalance(), const CoordinatorAudit()][index];
      case 'admin':
        return [const AdminDashboard(), const AdminUsers(), const AdminConfig(), const AdminStats()][index];
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      // key forces reveal animations to replay on navigation/role change
      child: KeyedSubtree(
        key: ValueKey('${state.role}-${state.navIndex}'),
        child: _body(state.role, state.navIndex),
      ),
    );

    return LayoutBuilder(
      builder: (context, cons) {
        final wide = cons.maxWidth >= 1000;
        if (wide) {
          return Scaffold(
            body: Row(children: [
              const AppSidebar(),
              Expanded(
                child: Column(children: [
                  const TopBar(showMenu: false),
                  Expanded(child: body),
                ]),
              ),
            ]),
          );
        }
        return Scaffold(
          drawer: Drawer(
            width: 264,
            child: Builder(
              builder: (drawerCtx) => AppSidebar(onTapItem: () => Navigator.of(drawerCtx).pop()),
            ),
          ),
          body: Builder(
            builder: (ctx) => Column(children: [
              TopBar(showMenu: true, onMenu: () => Scaffold.of(ctx).openDrawer()),
              Expanded(child: body),
            ]),
          ),
        );
      },
    );
  }
}