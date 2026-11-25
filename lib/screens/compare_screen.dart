import 'package:flutter/material.dart';

/// Placeholder - nanti: input 1 produk, bandingkan profit di semua marketplace.
class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bandingkan Marketplace'),
        backgroundColor: const Color(0xFF6C3BD8),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Perbandingan marketplace segera hadir',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
