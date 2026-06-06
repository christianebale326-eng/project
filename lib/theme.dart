import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized color palette (academic SaaS: warm off-white + amber + deep slate).
class C {
  static const bg = Color(0xFFFAF9F7);
  static const ink = Color(0xFF0F172A);
  static const inkSoft = Color(0xFF1E293B);
  static const amber = Color(0xFFF59E0B);
  static const amberDark = Color(0xFFD97706);
  static const amberSoft = Color(0xFFFEF3C7);
  static const emerald = Color(0xFF10B981);
  static const emeraldSoft = Color(0xFFD1FAE5);
  static const sky = Color(0xFF0EA5E9);
  static const skySoft = Color(0xFFE0F2FE);
  static const rose = Color(0xFFF43F5E);
  static const roseSoft = Color(0xFFFFE4E6);
  static const orange = Color(0xFFF97316);
  static const orangeSoft = Color(0xFFFFEDD5);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate700 = Color(0xFF334155);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);
  static const border = Color(0xFFEAE7E2);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.amber,
      primary: C.amber,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: C.bg,
  );
  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme),
  );
}

/// Fraunces display style for headings.
TextStyle display({
  double size = 24,
  FontWeight weight = FontWeight.w700,
  Color color = C.inkSoft,
}) =>
    GoogleFonts.fraunces(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.3,
    );

/// Color tone for a 0..1 match score.
Color toneColor(double s) {
  if (s >= 0.4) return C.emerald;
  if (s >= 0.2) return C.amber;
  if (s > 0) return C.orange;
  return C.rose;
}
