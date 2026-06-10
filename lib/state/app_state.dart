import 'package:flutter/foundation.dart';
import '../models/faculty.dart';
import '../models/student.dart';
import '../models/app_user.dart';
import '../data/sample_data.dart';

class AppState extends ChangeNotifier {
  bool loggedIn = false;
  String role = 'student';
  int navIndex = 0;

  double threshold = 0.05;
  int responseHours = 48;

  final List<Faculty> faculty = sampleFaculty();
  final List<Student> students = sampleStudents();

  // ---- Accounts -----------------------------------------------------------
  // Seeded demo accounts so the app can be used without registering first.
  // (Password for all demo accounts: 123456)
  final List<AppUser> users = [
    AppUser(id: 'u1', name: 'Maria Lopez', email: 'maria@adssu.edu', password: '123456', role: 'student'),
    AppUser(id: 'u2', name: 'Dr. Elena Marquez', email: 'marquez@adssu.edu', password: '123456', role: 'faculty'),
    AppUser(id: 'u3', name: 'Prof. Jeanie Delos Arcos', email: 'arcos@adssu.edu', password: '123456', role: 'coordinator'),
    AppUser(id: 'u4', name: 'System Admin', email: 'admin@adssu.edu', password: '123456', role: 'admin'),
  ];

  AppUser? currentUser;

  List<String> notifications = [
    'Your defense has been scheduled for June 16, 2026.',
    'Dr. Marquez accepted your adviser assignment.',
  ];

  /// Sign in with email + password. Returns an error message, or null on success.
  String? signIn(String email, String password) {
    final e = email.trim().toLowerCase();
    if (e.isEmpty || password.isEmpty) {
      return 'Please enter your email and password.';
    }
    AppUser? match;
    for (final u in users) {
      if (u.email.toLowerCase() == e && u.password == password) {
        match = u;
        break;
      }
    }
    if (match == null) {
      return 'Incorrect email or password.';
    }
    currentUser = match;
    role = match.role;
    navIndex = 0;
    loggedIn = true;
    notifyListeners();
    return null;
  }

  /// Register a new account, then sign in. Returns an error message, or null on success.
  String? register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    final n = name.trim();
    final e = email.trim().toLowerCase();
    if (n.isEmpty) return 'Please enter your full name.';
    if (!e.contains('@') || !e.contains('.')) return 'Please enter a valid email address.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    if (users.any((u) => u.email.toLowerCase() == e)) {
      return 'An account with this email already exists.';
    }
    final user = AppUser(
      id: 'u${users.length + 1}',
      name: n,
      email: e,
      password: password,
      role: role,
    );
    users.add(user);
    currentUser = user;
    this.role = role;
    navIndex = 0;
    loggedIn = true;
    notifyListeners();
    return null;
  }

  void logout() {
    loggedIn = false;
    currentUser = null;
    navIndex = 0;
    notifyListeners();
  }

  void setNav(int i) {
    navIndex = i;
    notifyListeners();
  }

  void setThreshold(double v) {
    threshold = v;
    notifyListeners();
  }

  void setResponseHours(int v) {
    responseHours = v;
    notifyListeners();
  }

  void setFacultyLoad(String id, {int? maxAdviser, int? maxPanel}) {
    final f = faculty.firstWhere((e) => e.id == id);
    if (maxAdviser != null) f.maxAdviserLoad = maxAdviser;
    if (maxPanel != null) f.maxPanelLoad = maxPanel;
    notifyListeners();
  }

  void pushNotif(String msg) {
    notifications.insert(0, msg);
    if (notifications.length > 6) {
      notifications = notifications.sublist(0, 6);
    }
    notifyListeners();
  }
}
