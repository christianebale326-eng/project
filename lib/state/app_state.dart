import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  AppUser? currentUser;

  List<String> notifications = [
    'Your defense has been scheduled for June 16, 2026.',
    'Dr. Marquez accepted your adviser assignment.',
  ];

  /// Sign in with email + password against Firebase Auth.
  /// Returns an error message, or null on success.
  Future<String?> signIn(String email, String password) async {
    final e = email.trim().toLowerCase();
    if (e.isEmpty || password.isEmpty) {
      return 'Please enter your email and password.';
    }
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: e,
        password: password,
      );
      final uid = cred.user!.uid;

      // Read the user's profile (name + role) from Firestore.
      final doc = await _db.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) {
        return 'Account has no profile data. Please register again.';
      }

      currentUser = AppUser(
        id: uid,
        name: data['name'] ?? '',
        email: e,
        password: '',
        role: data['role'] ?? 'student',
      );
      role = currentUser!.role;
      navIndex = 0;
      loggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (err) {
      return _authMessage(err);
    } catch (err) {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Register a new account in Firebase Auth, save profile to Firestore, then sign in.
  /// Returns an error message, or null on success.
  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final n = name.trim();
    final e = email.trim().toLowerCase();
    if (n.isEmpty) return 'Please enter your full name.';
    if (!e.contains('@') || !e.contains('.')) return 'Please enter a valid email address.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: e,
        password: password,
      );
      final uid = cred.user!.uid;

      // Save name + role to Firestore so we can read them on future logins.
      await _db.collection('users').doc(uid).set({
        'name': n,
        'email': e,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      currentUser = AppUser(
        id: uid,
        name: n,
        email: e,
        password: '',
        role: role,
      );
      this.role = role;
      navIndex = 0;
      loggedIn = true;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (err) {
      return _authMessage(err);
    } catch (err) {
      return 'Something went wrong. Please try again.';
    }
  }

  /// Turn Firebase error codes into friendly messages.
  String _authMessage(FirebaseAuthException err) {
    switch (err.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      default:
        return err.message ?? 'Authentication failed.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
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