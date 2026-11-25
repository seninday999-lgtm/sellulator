import 'package:flutter/material.dart';
import '../models/marketplace.dart';

/// Placeholder — nanti diganti kalkulator per marketplace.
class MarketplaceScreen extends StatelessWidget {
  final Marketplace marketplace;
  const MarketplaceScreen({super.key, required this.marketplace});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator ${marketplace.name}'),
        backgroundColor: marketplace.color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          'Kalkulator ${marketplace.name} segera hadir',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
