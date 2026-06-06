import 'package:flutter/foundation.dart';
import '../models/faculty.dart';
import '../models/student.dart';
import '../data/sample_data.dart';

class AppState extends ChangeNotifier {
  bool loggedIn = false;
  String role = 'student';
  int navIndex = 0;

  double threshold = 0.05;
  int responseHours = 48;

  final List<Faculty> faculty = sampleFaculty();
  final List<Student> students = sampleStudents();

  List<String> notifications = [
    'Your defense has been scheduled for June 16, 2026.',
    'Dr. Marquez accepted your adviser assignment.',
  ];

  void login(String r) {
    role = r;
    navIndex = 0;
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  void switchRole(String r) {
    role = r;
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
