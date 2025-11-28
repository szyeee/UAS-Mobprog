// lib/screens/menu/menu_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'menu_detail_screen.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar.dart'; // <-- tetap import ini (CustomSearchBar)

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ProductProvider>();

    if (prov.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// 🔍 Filter berdasarkan pencarian
    final filtered = prov.items
        .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: Column(
        children: [
          /// 🔍 Search bar — gunakan CustomSearchBar bukan SearchBar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: CustomSearchBar(
              hint: "Cari menu ...",
              onChanged: (val) => setState(() => keyword = val),
            ),
          ),

          const SizedBox(height: 4),

          /// 📦 Daftar produk
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
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
                  pinkIcon: true,
                  shadow: true,
                  rounded: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuDetailScreen(productId: p.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
