import 'package:flutter/material.dart';

class PromoScreen extends StatelessWidget {
  const PromoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo Tersedia'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _promoItem(
            title: 'Diskon 30% Semua Sushi',
            desc: 'Berlaku hari ini saja!',
            image: 'assets/images/banners/onboarding.png',
          ),
          const SizedBox(height: 14),
          _promoItem(
            title: 'Buy 1 Get 1 Takoyaki',
            desc: 'Tanpa minimal pembelian',
            image: 'assets/images/banners/onboarding.png',
          ),
          const SizedBox(height: 14),
          _promoItem(
            title: 'Gratis Ongkir',
            desc: 'Min. order Rp 50.000',
            image: 'assets/images/banners/onboarding.png',
          ),
        ],
      ),
    );
  }

  Widget _promoItem({
    required String title,
    required String desc,
    required String image,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.pink.shade50,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
          opacity: 0.18,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
