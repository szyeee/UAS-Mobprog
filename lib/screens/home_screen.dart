import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import 'promo_screen.dart';
import 'menu/menu_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selected = 'all';

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductProvider>();

    if (prov.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final items = prov.items;

    final cats = [
      'all',
      ...items.map((p) => prov.normalizeCategory(p.category)).toSet(),
    ];

    final filtered = _selected == 'all'
        ? items
        : items
            .where(
              (p) =>
                  prov.normalizeCategory(p.category) ==
                  prov.normalizeCategory(_selected),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SushiOrder'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PromoScreen()),
            ),
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.pink.shade200,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: prov.loadProducts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ PROMO CAROUSEL DI SINI
              PromoCarousel(
                banners: [
                  'assets/images/banners/onboarding.png',
                  'assets/images/banners/onboarding.png',
                  'assets/images/banners/onboarding.png',
                ],
              ),

              const SizedBox(height: 16),

              /// ✅ Categories
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final c = cats[i];
                    final active = prov.normalizeCategory(_selected) ==
                        prov.normalizeCategory(c);

                    return CategoryChip(
                      label: c,
                      selected: active,
                      onTap: () => setState(() => _selected = c),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// ✅ Product Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (ctx, i) {
                  final p = filtered[i];

                  return ProductCard(
                    id: p.id,
                    title: p.name,
                    image: p.imageUrl.startsWith('assets/')
                        ? p.imageUrl
                        : 'assets/${p.imageUrl}',
                    price: p.price,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuDetailScreen(productId: p.id),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
