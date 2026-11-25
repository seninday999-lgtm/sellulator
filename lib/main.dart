import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:window_manager/window_manager.dart';

import 'app/nav.dart';
import 'app/settings.dart';
import 'app/theme.dart';
import 'app/update.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/app_title_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.instance.load();

  // Jendela tanpa title bar bawaan Windows (diganti AppTitleBar), dibuka penuh.
  if (isDesktopApp) {
    await windowManager.ensureInitialized();
    const options = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(980, 640),
      center: true,
      title: 'Sellulator',
      titleBarStyle: TitleBarStyle.hidden,
      backgroundColor: Colors.transparent,
    );
    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.maximize();
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Lisensi font Inter (SIL OFL) tampil di halaman Lisensi.
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['Inter (font)'], text);
  });

  runApp(const SellulatorApp());

  // Cek pembaruan otomatis 2 detik setelah app terbuka.
  Future.delayed(const Duration(seconds: 2), Updater.checkOnStartup);
}

class SellulatorApp extends StatelessWidget {
  const SellulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        final st = AppSettings.instance;
        return MaterialApp(
          title: 'Sellulator',
          navigatorKey: appNavKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(st.bgColor(false)),
          darkTheme: AppTheme.dark(st.bgColor(true)),
          themeMode: st.themeMode,
          builder: (context, child) =>
              AppFrame(child: child ?? const SizedBox.shrink()),
          home: const DashboardScreen(),
        );
      },
    );
  }
}
