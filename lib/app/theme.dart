import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0A4BD8);
  static const Color navy = Color(0xFF021A5C);
  static const Color accent = Color(0xFFFF8A00);

  /// Font Inter (assets/fonts, didaftarkan di pubspec.yaml).
  static const String font = 'Inter';

  /// [bg] = warna latar halaman (dipilih di Pengaturan).
  static ThemeData light(Color bg) => _build(false, bg);
  static ThemeData dark(Color bg) => _build(true, bg);

  static ThemeData _build(bool dark, Color bg) {
    final card = dark ? const Color(0xFF1C1C1E) : Colors.white;
    final text = dark ? const Color(0xFFF2F2F7) : const Color(0xFF1C1C1E);
    final line = dark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA);
    final blue = dark ? const Color(0xFF5B8CFF) : primary;
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: blue,
      secondary: accent,
      surface: card,
    );
    final base = dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    return ThemeData(
      useMaterial3: true,
      fontFamily: font,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      // Transisi halaman ala iOS (geser dari kanan) di semua platform.
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final p in TargetPlatform.values)
            p: const CupertinoPageTransitionsBuilder(),
        },
      ),
      dividerTheme: DividerThemeData(color: line, thickness: 0.5, space: 1),
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: font,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: Colors.white,
        ),
      ),
      textTheme: base.apply(
        fontFamily: font,
        bodyColor: text,
        displayColor: text,
      ),
    );
  }
}
