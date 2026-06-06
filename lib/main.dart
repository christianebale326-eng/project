import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'state/app_state.dart';
import 'pages/login_page.dart';
import 'pages/shell_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const CapmatchApp(),
    ),
  );
}

class CapmatchApp extends StatelessWidget {
  const CapmatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAPMATCH',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const _Root(),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.select<AppState, bool>((s) => s.loggedIn);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: loggedIn ? const ShellPage() : const LoginPage(),
    );
  }
}
