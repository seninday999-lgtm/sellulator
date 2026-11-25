import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../app/nav.dart';
import '../app/theme.dart';
import '../screens/settings_screen.dart' show showSettingsPopup;

bool get isDesktopApp =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

/// Membungkus seluruh app: title bar kustom di atas, isi app di bawahnya.
class AppFrame extends StatelessWidget {
  const AppFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isDesktopApp) return child;
    return Column(
      children: [
        const AppTitleBar(),
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, c) => MediaQuery(
              data: MediaQuery.of(
                ctx,
              ).copyWith(size: Size(c.maxWidth, c.maxHeight)),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

/// Title bar kustom: logo + nama di kiri (area geser jendela), lalu Pengaturan
/// dan kontrol jendela (minimize / maximize / tutup) sejajar di kanan.
class AppTitleBar extends StatefulWidget {
  const AppTitleBar({super.key});

  @override
  State<AppTitleBar> createState() => _AppTitleBarState();
}

class _AppTitleBarState extends State<AppTitleBar> with WindowListener {
  bool _max = false;
  final _gearKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.isMaximized().then((v) {
      if (mounted) setState(() => _max = v);
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() => setState(() => _max = true);

  @override
  void onWindowUnmaximize() => setState(() => _max = false);

  void _toggleMax() =>
      _max ? windowManager.unmaximize() : windowManager.maximize();

  void _openSettings() {
    final box = _gearKey.currentContext?.findRenderObject() as RenderBox?;
    final ctx = appNavKey.currentContext;
    if (box == null || ctx == null) return;
    showSettingsPopup(ctx, anchor: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 16, right: 8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.navy, AppTheme.primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: DragToMoveArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onDoubleTap: _toggleMax,
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Sellulator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _TBtn(
              key: _gearKey,
              icon: Icons.settings_rounded,
              onTap: _openSettings,
            ),
            Container(
              width: 1,
              height: 18,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: Colors.white24,
            ),
            _TBtn(icon: Icons.remove, onTap: windowManager.minimize),
            _TBtn(
              icon: _max ? Icons.filter_none : Icons.crop_square,
              size: _max ? 15 : 17,
              onTap: _toggleMax,
            ),
            _TBtn(icon: Icons.close, danger: true, onTap: windowManager.close),
          ],
        ),
      ),
    );
  }
}

class _TBtn extends StatefulWidget {
  const _TBtn({
    super.key,
    required this.icon,
    required this.onTap,
    this.danger = false,
    this.size = 18,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;
  final double size;

  @override
  State<_TBtn> createState() => _TBtnState();
}

class _TBtnState extends State<_TBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final hoverColor = widget.danger
        ? const Color(0xFFE81123)
        : Colors.white.withValues(alpha: 0.16);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 44,
          height: 34,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: _hover ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(widget.icon, size: widget.size, color: Colors.white),
        ),
      ),
    );
  }
}
