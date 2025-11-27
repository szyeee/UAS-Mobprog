import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart'; // SESUAIKAN PATH

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  final double price;
  final VoidCallback? onTap;

  final bool pinkIcon;
  final bool shadow;
  final bool rounded;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.onTap,
    this.pinkIcon = true,
    this.shadow = true,
    this.rounded = true,
  });

  bool _isNetwork(String path) {
    return path.startsWith("http://") || path.startsWith("https://");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(rounded ? 16 : 0),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(rounded ? 16 : 0),
                  ),
                  child: _isNetwork(image)
                      ? Image.network(
                          image,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          image,
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),

                // ❤️ ICON FAVORITE
                if (pinkIcon)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Consumer<FavoriteProvider>(
                      builder: (context, fav, _) {
                        final isFav = fav.isFavorite(id);

                        return GestureDetector(
                          onTap: () {
                            fav.toggleFavorite({
                              'id': id,
                              'name': title,
                              'image': image,
                              'price': price,
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: isFav ? Colors.pink : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),

            // TEXT AREA
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12),
              child: Text(
                "Rp ${price.toStringAsFixed(0)}",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
