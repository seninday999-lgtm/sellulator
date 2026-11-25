import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, ThemeMode;
import 'package:path/path.dart' as pth;
import 'package:path_provider/path_provider.dart';

/// Samakan dengan `version:` di pubspec.yaml setiap kali rilis.
const String kAppVersion = '1.0.0';
const String kAppBuild = '1';

/// Alamat file JSON update (kosong = belum diatur, bisa diisi dari menu
/// Pengaturan). Format: {"version":"1.0.1","url":"https://...","notes":"..."}
const String kUpdateJsonUrl = '';

class BgOption {
  const BgOption(this.name, this.color);
  final String name;
  final Color color;
}

const List<BgOption> kLightBgs = [
  BgOption('Abu iOS', Color(0xFFF2F2F7)),
  BgOption('Biru lembut', Color(0xFFE8EEFA)),
  BgOption('Krem', Color(0xFFF5F0E6)),
  BgOption('Mint', Color(0xFFE8F3EC)),
];

const List<BgOption> kDarkBgs = [
  BgOption('Hitam', Color(0xFF000000)),
  BgOption('Abu gelap', Color(0xFF141416)),
  BgOption('Biru malam', Color(0xFF0B1220)),
];

/// Pengaturan aplikasi (disimpan di …/sellulator/app_settings.json).
class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  bool followSystem = true; // mode tampilan mengikuti sistem
  bool dark = false; // dipakai bila followSystem = false
  int bgLight = 0;
  int bgDark = 0;
  String userName = '';
  String shopName = '';
  String email = '';
  String updateUrl = kUpdateJsonUrl;

  ThemeMode get themeMode => followSystem
      ? ThemeMode.system
      : (dark ? ThemeMode.dark : ThemeMode.light);

  Color bgColor(bool isDark) {
    final list = isDark ? kDarkBgs : kLightBgs;
    final i = isDark ? bgDark : bgLight;
    return list[i.clamp(0, list.length - 1)].color;
  }

  Future<File> _file() async {
    final dir = Directory(
      pth.join((await getApplicationSupportDirectory()).path, 'sellulator'),
    );
    if (!await dir.exists()) await dir.create(recursive: true);
    return File(pth.join(dir.path, 'app_settings.json'));
  }

  Future<void> load() async {
    try {
      final f = await _file();
      if (!await f.exists()) return;
      final m = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      followSystem = m['followSystem'] != false;
      dark = m['dark'] == true;
      bgLight = (m['bgLight'] as num?)?.toInt() ?? 0;
      bgDark = (m['bgDark'] as num?)?.toInt() ?? 0;
      userName = (m['userName'] as String?) ?? '';
      shopName = (m['shopName'] as String?) ?? '';
      email = (m['email'] as String?) ?? '';
      updateUrl = (m['updateUrl'] as String?) ?? kUpdateJsonUrl;
    } catch (_) {
      // file rusak / belum ada → pakai bawaan
    }
  }

  Future<void> _save() async {
    try {
      await (await _file()).writeAsString(
        jsonEncode({
          'followSystem': followSystem,
          'dark': dark,
          'bgLight': bgLight,
          'bgDark': bgDark,
          'userName': userName,
          'shopName': shopName,
          'email': email,
          'updateUrl': updateUrl,
        }),
      );
    } catch (_) {}
  }

  /// Ubah nilai lalu simpan dan beri tahu pendengar (tema ikut berubah).
  void update(VoidCallback change) {
    change();
    notifyListeners();
    _save();
  }

  void resetAll() => update(() {
    followSystem = true;
    dark = false;
    bgLight = 0;
    bgDark = 0;
    userName = '';
    shopName = '';
    email = '';
    updateUrl = kUpdateJsonUrl;
  });
}
