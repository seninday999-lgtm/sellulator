import 'package:flutter/material.dart';

/// Placeholder - nanti: kalkulator iklan (ROAS, BEP ROAS, ACOS, budget).
class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Iklan'),
        backgroundColor: const Color(0xFFFF8A00),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Kalkulator iklan segera hadir',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
