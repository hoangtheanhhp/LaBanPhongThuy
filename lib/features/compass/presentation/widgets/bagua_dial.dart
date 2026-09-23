import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bat_trach_calculator.dart';

class BaguaDial extends StatelessWidget {
  final double size;
  final CungPhi? activeCungPhi;

  const BaguaDial({
    super.key,
    required this.size,
    this.activeCungPhi,
  });

  static const List<Map<String, dynamic>> baguaSectors = [
    {'name': 'Khảm', 'trigram': '☵', 'sub': 'Thủy', 'angle': 0.0},
    {'name': 'Cấn', 'trigram': '☶', 'sub': 'Thổ', 'angle': 45.0},
    {'name': 'Chấn', 'trigram': '☳', 'sub': 'Mộc', 'angle': 90.0},
    {'name': 'Tốn', 'trigram': '☴', 'sub': 'Mộc', 'angle': 135.0},
    {'name': 'Ly', 'trigram': '☲', 'sub': 'Hỏa', 'angle': 180.0},
    {'name': 'Khôn', 'trigram': '☷', 'sub': 'Thổ', 'angle': 225.0},
    {'name': 'Đoài', 'trigram': '☱', 'sub': 'Kim', 'angle': 270.0},
    {'name': 'Càn', 'trigram': '☰', 'sub': 'Kim', 'angle': 315.0},
  ];

  @override
  Widget build(BuildContext context) {
    final directionMeanings = activeCungPhi != null
        ? BatTrachCalculator.getDirectionMeanings(activeCungPhi!)
        : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Dial Geometry
          CustomPaint(
            size: Size(size, size),
            painter: _BaguaDialPainter(),
          ),
          // 8 Directional Bagua Sectors
          for (final sector in baguaSectors)
            Transform.rotate(
              angle: (sector['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Trigram symbol
                      Text(
                        sector['trigram'],
                        style: TextStyle(
                          color: sector['angle'] == 0 ? AppColors.northRed : AppColors.primaryGold,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Bagua Name
                      Text(
                        sector['name'],
                        style: TextStyle(
                          color: sector['angle'] == 0 ? AppColors.northRed : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      // Element / Ngu Hanh
                      Text(
                        sector['sub'],
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                      // Bát Trạch Auspicious / Inauspicious Tag if user profile is set
                      if (directionMeanings != null) ...[
                        const SizedBox(height: 2),
                        Builder(
                          builder: (context) {
                            final meaning = directionMeanings[(sector['angle'] as double).toInt()];
                            if (meaning == null) return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: meaning.isGood
                                    ? AppColors.goodDirection.withOpacity(0.2)
                                    : AppColors.badDirection.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: meaning.isGood
                                      ? AppColors.goodDirection
                                      : AppColors.badDirection,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                meaning.name,
                                style: TextStyle(
                                  color: meaning.isGood
                                      ? AppColors.goodDirection
                                      : AppColors.badDirection,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          // Center Yin-Yang / Thái Cực Core
          Container(
            width: size * 0.22,
            height: size * 0.22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: AppColors.primaryGold, width: 2),
            ),
            child: const Center(
              child: Text(
                '☯',
                style: TextStyle(color: AppColors.primaryGold, fontSize: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaguaDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer concentric rings
    final ringPaint = Paint()
      ..color = AppColors.primaryGold.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius - 2, ringPaint);
    canvas.drawCircle(center, radius * 0.72, ringPaint);
    canvas.drawCircle(center, radius * 0.25, ringPaint);

    // 8 Sector Divider Lines
    final linePaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45.0 + 22.5) * (math.pi / 180.0);
      final p1 = Offset(center.dx + radius * 0.25 * math.cos(angle), center.dy + radius * 0.25 * math.sin(angle));
      final p2 = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(p1, p2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
