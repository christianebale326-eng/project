/// A registered account. For this prototype, credentials are held in memory
/// only — there is no backend, so passwords are stored in plain text and are
/// lost when the app restarts. Replace with Firebase Auth (or similar) for a
/// real deployment.
class AppUser {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role; // 'student' | 'faculty' | 'coordinator' | 'admin'

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
