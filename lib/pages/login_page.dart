import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../state/app_state.dart';
import '../data/nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool registerMode = false;
  bool obscure = true;
  String? error;

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String selectedRole = 'student';

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _submit(AppState state) async {
    final err = registerMode
        ? await state.register(
            name: name.text,
            email: email.text,
            password: password.text,
            role: selectedRole,
          )
        : await state.signIn(email.text, password.text);
    if (err != null) {
      setState(() => error = err);
    }
    // On success the root widget swaps to the dashboard automatically.
  }

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
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Powered by Firebase',
                      style: TextStyle(color: C.amber, fontSize: 11, fontWeight: FontWeight.w700)),
                  SizedBox(height: 6),
                  Text('Create an account to get started — your login is securely stored in the cloud.',
                      style: TextStyle(color: C.slate400, fontSize: 12, height: 1.6)),
                ],
              ),
            ),
          ]),
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text('Agusan del Sur State University · College of Computing & Information Sciences',
                style: TextStyle(color: C.slate500, fontSize: 12)),
          ),
        ],
      ),
    );

    final form = Container(
      padding: const EdgeInsets.all(40),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(registerMode ? 'Create your account' : 'Sign in', style: display(size: 24)),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            child: Text(
              registerMode
                  ? 'Register to access your CapMatch dashboard.'
                  : 'Enter your credentials to continue.',
              style: const TextStyle(color: C.slate400, fontSize: 14),
            ),
          ),
          if (registerMode) ...[
            _label('Full Name'),
            TextField(controller: name, decoration: _dec('e.g. Juan Dela Cruz')),
            const SizedBox(height: 14),
          ],
          _label('Email'),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: _dec('you@adssu.edu'),
          ),
          const SizedBox(height: 14),
          _label('Password'),
          TextField(
            controller: password,
            obscureText: obscure,
            decoration: _dec('••••••••').copyWith(
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 18, color: C.slate400),
                onPressed: () => setState(() => obscure = !obscure),
              ),
            ),
            onSubmitted: (_) => _submit(state),
          ),
          if (registerMode) ...[
            const SizedBox(height: 16),
            _label('I am a...'),
            const SizedBox(height: 2),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in roleOrder)
                  _RoleChip(
                    role: r,
                    selected: selectedRole == r,
                    onTap: () => setState(() => selectedRole = r),
                  ),
              ],
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: C.roseSoft, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.error_outline, color: C.rose, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(error!, style: const TextStyle(color: C.rose, fontSize: 13, fontWeight: FontWeight.w600))),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _submit(state),
              style: ElevatedButton.styleFrom(
                backgroundColor: C.ink, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(registerMode ? 'Create Account' : 'Sign In',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(registerMode ? 'Already have an account?' : "Don't have an account?",
                  style: const TextStyle(color: C.slate400, fontSize: 13)),
              TextButton(
                onPressed: () => setState(() {
                  registerMode = !registerMode;
                  error = null;
                }),
                child: Text(registerMode ? 'Sign in' : 'Register',
                    style: const TextStyle(color: C.amberDark, fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ],
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
                  Expanded(child: form),
                ]),
              )
            : Column(mainAxisSize: MainAxisSize.min, children: [brand, form]),
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

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: C.slate500)),
      );

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: C.slate400, fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.amber, width: 1.5)),
      );
}

class _RoleChip extends StatelessWidget {
  final String role;
  final bool selected;
  final VoidCallback onTap;
  const _RoleChip({required this.role, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final m = roleMeta[role]!;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? C.amberSoft : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? C.amber : C.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(m.icon, size: 15, color: selected ? C.amberDark : C.slate500),
            const SizedBox(width: 6),
            Text(m.label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? C.amberDark : C.slate500)),
          ],
        ),
      ),
    );
  }
}