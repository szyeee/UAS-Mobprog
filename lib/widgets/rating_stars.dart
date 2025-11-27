// lib/widgets/rating_stars.dart
import 'package:flutter/material.dart';

/// Simple star rating widget.
/// - [rating] initial value (0.0 - 5.0)
/// - [onRatingChanged] optional callback when rating changes
class RatingStars extends StatelessWidget {
  final double rating;
  final ValueChanged<double>? onRatingChanged;
  final double size;
  final bool allowHalf;

  const RatingStars({
    super.key,
    this.rating = 5.0,
    this.onRatingChanged,
    this.size = 20,
    this.allowHalf = true,
  });

  Widget _buildStar(BuildContext context, int index) {
    final int whole = rating.floor();
    final bool isHalf = allowHalf && (rating - whole) >= (index - whole - 0.5) && (rating < index);
    final IconData icon;
    if (index <= rating.floor()) {
      icon = Icons.star;
    } else if (isHalf) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star_border;
    }

    return GestureDetector(
      onTap: onRatingChanged == null ? null : () {
        final newRating = index.toDouble();
        onRatingChanged!(newRating);
      },
      child: Icon(icon, size: size, color: Colors.amber),
    );
  }

  @override
  Widget build(BuildContext context) {
    // show 5 stars
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => _buildStar(context, i + 1)),
    );
  }
}

