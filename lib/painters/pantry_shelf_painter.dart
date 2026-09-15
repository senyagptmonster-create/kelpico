import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../theme/kelpico_theme.dart';

class PantryShelfPainter extends CustomPainter {
  final List<PantryItem> items;

  PantryShelfPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final shelfWoodPaint = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..style = PaintingStyle.fill;

    final shelfShadowPaint = Paint()
      ..color = const Color(0xFF8D6E63).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final shelfCount = 3;
    final shelfHeight = 12.0;
    final rowSpacing = (size.height - (shelfCount * shelfHeight)) / shelfCount;

    for (int i = 1; i <= shelfCount; i++) {
      final y = i * (rowSpacing + shelfHeight) - shelfHeight;
      // Shelf board
      final shelfRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(8, y, size.width - 16, shelfHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(shelfRect, shelfWoodPaint);

      // Shadow under shelf
      canvas.drawRect(
        Rect.fromLTWH(12, y + shelfHeight, size.width - 24, 4),
        shelfShadowPaint,
      );

      // Draw jars/packages standing on shelf
      final shelfItems = items.skip((i - 1) * 3).take(3).toList();
      double startX = 24.0;
      for (int j = 0; j < shelfItems.length; j++) {
        final item = shelfItems[j];
        final jarWidth = 36.0;
        final jarHeight = 38.0;
        final jarTop = y - jarHeight;

        // Container body
        final jarColor = item.daysToExpiry <= 3
            ? KelpicoTheme.red.withValues(alpha: 0.8)
            : (item.daysToExpiry <= 7
                ? KelpicoTheme.accentLight
                : KelpicoTheme.accent.withValues(alpha: 0.7));

        final jarPaint = Paint()..color = jarColor;
        final jarRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(startX, jarTop, jarWidth, jarHeight),
          const Radius.circular(6),
        );
        canvas.drawRRect(jarRect, jarPaint);

        // Cap
        final capPaint = Paint()..color = KelpicoTheme.ink.withValues(alpha: 0.7);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX + 6, jarTop - 6, jarWidth - 12, 6),
            const Radius.circular(2),
          ),
          capPaint,
        );

        // Expiry status dot on jar
        final dotPaint = Paint()
          ..color = item.daysToExpiry <= 3 ? Colors.white : KelpicoTheme.green;
        canvas.drawCircle(Offset(startX + jarWidth / 2, jarTop + jarHeight / 2), 4, dotPaint);

        startX += jarWidth + 24.0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant PantryShelfPainter oldDelegate) {
    return oldDelegate.items.length != items.length;
  }
}
