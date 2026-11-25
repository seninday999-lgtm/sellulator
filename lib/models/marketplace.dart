import 'package:flutter/material.dart';

class Marketplace {
  final String id;
  final String name;
  final String tagline;
  final Color color;
  final IconData fallbackIcon;

  /// Path logo (opsional). Kalau null / file belum ada -> pakai fallbackIcon.
  final String? assetPath;

  const Marketplace({
    required this.id,
    required this.name,
    required this.tagline,
    required this.color,
    required this.fallbackIcon,
    this.assetPath,
  });
}

/// Daftar marketplace. Logo di assets/marketplace/<nama>.png
const List<Marketplace> kMarketplaces = [
  Marketplace(
    id: 'shopee',
    name: 'Shopee',
    tagline: 'Biaya admin & voucher',
    color: Color(0xFFEE4D2D),
    fallbackIcon: Icons.shopping_bag_rounded,
    assetPath: 'assets/marketplace/shopee.png',
  ),
  Marketplace(
    id: 'lazada',
    name: 'Lazada',
    tagline: 'Komisi & biaya bayar',
    color: Color(0xFF0F146D),
    fallbackIcon: Icons.favorite_rounded,
    assetPath: 'assets/marketplace/lazada.png',
  ),
  Marketplace(
    id: 'tiktok_shop',
    name: 'TikTok Shop',
    tagline: 'Komisi & affiliate',
    color: Color(0xFF161823),
    fallbackIcon: Icons.music_note_rounded,
    assetPath: 'assets/marketplace/tiktok_shop.png',
  ),
  Marketplace(
    id: 'blibli',
    name: 'Blibli',
    tagline: 'Komisi kategori',
    color: Color(0xFF0095DA),
    fallbackIcon: Icons.storefront_rounded,
    assetPath: 'assets/marketplace/blibli.png',
  ),
  Marketplace(
    id: 'akulaku',
    name: 'Akulaku',
    tagline: 'Komisi & cicilan',
    color: Color(0xFFE60012),
    fallbackIcon: Icons.credit_card_rounded,
    assetPath: 'assets/marketplace/akulaku.png',
  ),
  Marketplace(
    id: 'toco',
    name: 'Toco',
    tagline: 'Biaya layanan',
    color: Color(0xFF42B549),
    fallbackIcon: Icons.local_mall_rounded,
    assetPath: 'assets/marketplace/toco.png',
  ),
];

/// Menu alat bantu (bukan marketplace). Logo: assets/marketplace/ads.png
/// dan compare.png (kalau belum ada, otomatis pakai ikon bawaan).
const List<Marketplace> kTools = [
  Marketplace(
    id: 'ads',
    name: 'Iklan',
    tagline: 'ROAS, BEP & biaya iklan',
    color: Color(0xFFFF8A00),
    fallbackIcon: Icons.campaign_rounded,
    assetPath: 'assets/marketplace/ads.png',
  ),
  Marketplace(
    id: 'compare',
    name: 'Bandingkan',
    tagline: 'Adu profit antar platform',
    color: Color(0xFF6C3BD8),
    fallbackIcon: Icons.compare_arrows_rounded,
    assetPath: 'assets/marketplace/compare.png',
  ),
  Marketplace(
    id: 'settings',
    name: 'Pengaturan',
    tagline: 'Akun, tampilan & update',
    color: Color(0xFF8E8E93),
    fallbackIcon: Icons.settings_rounded,
    assetPath: 'assets/marketplace/settings.png',
  ),
];
