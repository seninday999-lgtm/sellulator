import 'package:flutter/material.dart';
import 'settings.dart';
import 'theme.dart';

/// Palet warna kalkulator bergaya iOS (grouped / system colors).
/// Panggil [syncPalette] di awal build layar kalkulator supaya ikut tema.
bool isDark = false;

void syncPalette(BuildContext context) {
  isDark = Theme.of(context).brightness == Brightness.dark;
}

Color get accent => isDark ? const Color(0xFF5B8CFF) : AppTheme.primary;

/// Latar halaman — mengikuti pilihan di Pengaturan.
Color get cBg => AppSettings.instance.bgColor(isDark);

/// Kartu / permukaan utama.
Color get cSurface => isDark ? const Color(0xFF1C1C1E) : Colors.white;

/// Isian input, tombol tidak aktif, dan area di dalam kartu.
Color get cSurface2 =>
    isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7);

Color get cText => isDark ? const Color(0xFFF2F2F7) : const Color(0xFF1C1C1E);
Color get cSub => isDark ? const Color(0xFFAEAEB2) : const Color(0xFF636366);
Color get cMute => const Color(0xFF8E8E93);

/// Garis pemisah tipis (iOS separator).
Color get cLine => isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA);
