import 'package:flutter/material.dart';
import '../app/settings.dart';
import '../app/theme.dart';
import '../calculators/shopee_calculator.dart';
import '../models/marketplace.dart';
import '../widgets/marketplace_card.dart';
import 'ads_screen.dart';
import 'compare_screen.dart';
import 'marketplace_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _openTool(BuildContext context, Marketplace t) {
    switch (t.id) {
      case 'ads':
        _open(context, const AdsScreen());
        break;
      case 'compare':
        _open(context, const CompareScreen());
        break;
      case 'settings':
        showSettingsPopup(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(40, 28, 40, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(
                    title: 'Pilih Marketplace',
                    subtitle:
                        'Hitung biaya admin, komisi, dan profit bersih per platform.',
                    items: kMarketplaces,
                    onTap: (m) => _open(
                      context,
                      m.id == 'shopee'
                          ? const ShopeeCalculatorScreen()
                          : MarketplaceScreen(marketplace: m),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _Section(
                    title: 'Alat Bantu',
                    subtitle:
                        'Hitung iklan, bandingkan profit, dan atur aplikasi.',
                    items: kTools,
                    onTap: (t) => _openTool(context, t),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Marketplace> items;
  final void Function(Marketplace) onTap;

  const _Section({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF8E8E93)),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            mainAxisExtent: 210,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) => MarketplaceCard(
            marketplace: items[i],
            onTap: () => onTap(items[i]),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        final name = AppSettings.instance.userName.trim();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.navy, AppTheme.primary],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Image.asset('assets/images/logo.png', width: 64, height: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sellulator',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                    Text(
                      name.isEmpty
                          ? 'Kalkulator biaya admin multi marketplace'
                          : 'Halo, $name · kalkulator biaya admin multi marketplace',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
