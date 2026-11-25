import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app/settings.dart';
import '../app/update.dart';

/// Membuka Pengaturan sebagai popup bergaya iOS.
/// [anchor] diisi (posisi ikon roda gigi) → popover menempel di ikon tersebut;
/// kosong → popup di tengah layar (dari kartu menu Pengaturan).
Future<void> showSettingsPopup(BuildContext context, {Rect? anchor}) {
  // Title bar kustom ada di atas Navigator → ubah posisi ikon (koordinat layar)
  // menjadi koordinat di area Navigator.
  final navBox = Navigator.of(context, rootNavigator: true).context
      .findRenderObject();
  var origin = Offset.zero;
  Size? avail;
  if (navBox is RenderBox && navBox.hasSize) {
    origin = navBox.localToGlobal(Offset.zero);
    avail = navBox.size;
  }
  final a = anchor?.shift(-origin);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup pengaturan',
    barrierColor: a == null ? Colors.black54 : Colors.black26,
    transitionDuration: const Duration(milliseconds: 190),
    pageBuilder: (ctx, _, __) {
      final size = avail ?? MediaQuery.of(ctx).size;
      if (a == null) {
        final w = math.min(560.0, size.width - 48);
        final h = math.min(720.0, size.height - 80);
        return Center(
          child: SizedBox(
            width: w,
            height: h,
            child: const _PopupShell(child: SettingsPanel()),
          ),
        );
      }
      final w = math.min(400.0, size.width - 24);
      final left = (a.right - w)
          .clamp(12.0, math.max(12.0, size.width - w - 12))
          .toDouble();
      // ikon ada di title bar (di atas area Navigator) → popover mulai dari tepi atas
      final top = math.max(a.bottom + 12, 14.0);
      final h = math.max(320.0, math.min(680.0, size.height - top - 16));
      final arrowX = (a.center.dx - left).clamp(28.0, w - 28).toDouble();
      return Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            width: w,
            height: h,
            child: _PopupShell(arrowX: arrowX, child: const SettingsPanel()),
          ),
        ],
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
          alignment: a == null ? Alignment.center : Alignment.topRight,
          child: child,
        ),
      );
    },
  );
}

/// Bingkai popup: sudut membulat, bayangan lembut, dan panah (untuk popover).
class _PopupShell extends StatelessWidget {
  const _PopupShell({required this.child, this.arrowX});
  final Widget child;
  final double? arrowX;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final bg = theme.scaffoldBackgroundColor;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: dark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA),
                width: 0.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 40,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
        if (arrowX != null)
          Positioned(
            top: -6,
            left: arrowX! - 8,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Isi Pengaturan: akun, tampilan (mode & latar), pembaruan, data.
class SettingsPanel extends StatefulWidget {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final _st = AppSettings.instance;
  bool _checking = false;
  String? _updateMsg; // hasil cek terakhir (teks kecil di bawah baris Update)

  bool get _dark => Theme.of(context).brightness == Brightness.dark;
  Color get _card => _dark ? const Color(0xFF1C1C1E) : Colors.white;
  Color get _line => _dark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA);
  Color get _sub => const Color(0xFF8E8E93);
  Color get _blue => Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    _st.addListener(_rebuild);
  }

  @override
  void dispose() {
    _st.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  // ---------------- komponen ----------------
  Widget _group(String? title, List<Widget> rows, {String? footer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 7),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.4,
                  fontWeight: FontWeight.w600,
                  color: _sub,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  rows[i],
                  if (i < rows.length - 1)
                    Divider(height: 0.5, thickness: 0.5, indent: 16, color: _line),
                ],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 0),
              child: Text(
                footer,
                style: TextStyle(fontSize: 12, height: 1.35, color: _sub),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required Color iconBg,
    required String title,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
    bool chevron = false,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            if (value != null)
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 14.5, color: _sub),
                ),
              ),
            if (trailing != null) trailing,
            if (chevron) ...[
              const SizedBox(width: 6),
              Icon(CupertinoIcons.chevron_right, size: 15, color: _sub),
            ],
          ],
        ),
      ),
    );
  }

  Widget _switch(bool v, ValueChanged<bool>? onChanged) => CupertinoSwitch(
    value: v,
    activeTrackColor: const Color(0xFF34C759),
    onChanged: onChanged,
  );

  // ---------------- dialog input (gaya iOS) ----------------
  Future<void> _editText({
    required String title,
    required String initial,
    required String hint,
    required void Function(String) onSave,
    TextInputType? keyboard,
  }) async {
    final c = TextEditingController(text: initial);
    final ok = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: c,
            placeholder: hint,
            autofocus: true,
            keyboardType: keyboard,
            onSubmitted: (_) => Navigator.pop(ctx, true),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (ok == true) _st.update(() => onSave(c.text.trim()));
    c.dispose();
  }

  Future<void> _alert(String title, String msg, {String ok = 'OK'}) =>
      showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(msg),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(ctx),
              child: Text(ok),
            ),
          ],
        ),
      );

  // ---------------- akun ----------------
  Widget _profileCard() {
    final name = _st.userName.isEmpty ? 'Pengguna Sellulator' : _st.userName;
    final initials = _st.userName.trim().isEmpty
        ? 'S'
        : _st.userName
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e[0].toUpperCase())
              .join();
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF021A5C), Color(0xFF0A4BD8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _st.shopName.isEmpty ? 'Nama toko belum diisi' : _st.shopName,
                  style: TextStyle(fontSize: 13.5, color: _sub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- latar ----------------
  Widget _swatches(String label, List<BgOption> list, int selected,
      ValueChanged<int> onPick, {required bool darkPreview}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 10,
            children: [
              for (var i = 0; i < list.length; i++)
                GestureDetector(
                  onTap: () => onPick(i),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 54,
                        height: 38,
                        decoration: BoxDecoration(
                          color: list[i].color,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: i == selected ? _blue : _line,
                            width: i == selected ? 2.5 : 1,
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Container(
                          width: 34,
                          height: 8,
                          decoration: BoxDecoration(
                            color: darkPreview
                                ? const Color(0xFF1C1C1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        list[i].name,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight:
                              i == selected ? FontWeight.w700 : FontWeight.w400,
                          color: i == selected ? _blue : _sub,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- update ----------------
  Future<void> _checkUpdate() async {
    setState(() {
      _checking = true;
      _updateMsg = null;
    });
    try {
      final info = await Updater.check();
      if (!mounted) return;
      if (info == null) {
        setState(() => _updateMsg = 'Sudah terbaru');
      } else {
        setState(() => _updateMsg = 'Versi ${info.version} tersedia');
        Updater.showUpdate(info);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _updateMsg = 'Gagal memeriksa update');
        await _alert('Gagal memeriksa update', '$e');
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  // ---------------- header popup ----------------
  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
    child: Row(
      children: [
        const SizedBox(width: 72),
        const Expanded(
          child: Center(
            child: Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 72,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(44, 36),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Selesai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _blue,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // ---------------- build ----------------
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          _header(),
          Divider(height: 0.5, thickness: 0.5, color: _line),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              children: [
              _profileCard(),

              _group('Akun', [
                _row(
                  icon: CupertinoIcons.person_fill,
                  iconBg: const Color(0xFF007AFF),
                  title: 'Nama',
                  value: _st.userName.isEmpty ? 'Belum diisi' : _st.userName,
                  chevron: true,
                  onTap: () => _editText(
                    title: 'Nama',
                    initial: _st.userName,
                    hint: 'Nama kamu',
                    onSave: (v) => _st.userName = v,
                  ),
                ),
                _row(
                  icon: CupertinoIcons.bag_fill,
                  iconBg: const Color(0xFFFF9500),
                  title: 'Nama toko',
                  value: _st.shopName.isEmpty ? 'Belum diisi' : _st.shopName,
                  chevron: true,
                  onTap: () => _editText(
                    title: 'Nama toko',
                    initial: _st.shopName,
                    hint: 'Nama toko / brand',
                    onSave: (v) => _st.shopName = v,
                  ),
                ),
                _row(
                  icon: CupertinoIcons.mail_solid,
                  iconBg: const Color(0xFF34C759),
                  title: 'Email',
                  value: _st.email.isEmpty ? 'Belum diisi' : _st.email,
                  chevron: true,
                  onTap: () => _editText(
                    title: 'Email',
                    initial: _st.email,
                    hint: 'nama@email.com',
                    keyboard: TextInputType.emailAddress,
                    onSave: (v) => _st.email = v,
                  ),
                ),
              ], footer: 'Data akun hanya tersimpan di perangkat ini.'),

              _group('Tampilan', [
                _row(
                  icon: CupertinoIcons.device_laptop,
                  iconBg: const Color(0xFF5856D6),
                  title: 'Ikuti sistem',
                  trailing: _switch(
                    _st.followSystem,
                    (v) => _st.update(() => _st.followSystem = v),
                  ),
                ),
                Opacity(
                  opacity: _st.followSystem ? 0.45 : 1,
                  child: _row(
                    icon: CupertinoIcons.moon_fill,
                    iconBg: const Color(0xFF1C1C1E),
                    title: 'Mode gelap',
                    trailing: _switch(
                      _st.followSystem ? _dark : _st.dark,
                      _st.followSystem
                          ? null
                          : (v) => _st.update(() => _st.dark = v),
                    ),
                  ),
                ),
                _swatches(
                  'Latar mode terang',
                  kLightBgs,
                  _st.bgLight,
                  (i) => _st.update(() => _st.bgLight = i),
                  darkPreview: false,
                ),
                _swatches(
                  'Latar mode gelap',
                  kDarkBgs,
                  _st.bgDark,
                  (i) => _st.update(() => _st.bgDark = i),
                  darkPreview: true,
                ),
              ], footer: 'Aktifkan "Ikuti sistem" agar tema mengikuti pengaturan Windows. Matikan untuk memilih terang / gelap sendiri.'),

              _group('Pembaruan', [
                _row(
                  icon: CupertinoIcons.info_circle_fill,
                  iconBg: const Color(0xFF8E8E93),
                  title: 'Versi aplikasi',
                  value: '$kAppVersion ($kAppBuild)',
                ),
                _row(
                  icon: CupertinoIcons.arrow_down_circle_fill,
                  iconBg: const Color(0xFF007AFF),
                  title: 'Periksa pembaruan',
                  trailing: _checking
                      ? const CupertinoActivityIndicator()
                      : (_updateMsg == null
                            ? null
                            : Text(
                                _updateMsg!,
                                style: TextStyle(fontSize: 13.5, color: _sub),
                              )),
                  chevron: !_checking,
                  onTap: _checking ? null : _checkUpdate,
                ),
              ]),

              _group('Tentang', [
                _row(
                  icon: CupertinoIcons.doc_text_fill,
                  iconBg: const Color(0xFFAF52DE),
                  title: 'Lisensi sumber terbuka',
                  chevron: true,
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Sellulator',
                    applicationVersion: '$kAppVersion ($kAppBuild)',
                    applicationIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 56,
                        height: 56,
                      ),
                    ),
                  ),
                ),
              ]),

              _group('Data', [
                _row(
                  icon: CupertinoIcons.arrow_counterclockwise,
                  iconBg: const Color(0xFFFF3B30),
                  title: 'Atur ulang pengaturan',
                  titleColor: const Color(0xFFFF3B30),
                  onTap: () async {
                    final ok = await showCupertinoDialog<bool>(
                      context: context,
                      builder: (ctx) => CupertinoAlertDialog(
                        title: const Text('Atur ulang pengaturan?'),
                        content: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Akun, tema, latar, dan sumber update kembali ke '
                            'bawaan. Data kalkulator tidak dihapus.',
                          ),
                        ),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Batal'),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Atur ulang'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) _st.resetAll();
                  },
                ),
              ]),

              Center(
                child: Text(
                  'Sellulator v$kAppVersion',
                  style: TextStyle(fontSize: 12, color: _sub),
                ),
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
