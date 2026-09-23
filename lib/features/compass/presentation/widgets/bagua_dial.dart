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

  static const List<Map<String, dynamic>> bagua8Directions = [
    {
      'name': 'CHÁNH BẮC',
      'cung': 'KHẢM',
      'angle': 0.0,
      'lines': [false, true, false],
    },
    {
      'name': 'ĐÔNG BẮC',
      'cung': 'CẤN',
      'angle': 45.0,
      'lines': [true, false, false],
    },
    {
      'name': 'CHÁNH ĐÔNG',
      'cung': 'CHẤN',
      'angle': 90.0,
      'lines': [false, false, true],
    },
    {
      'name': 'ĐÔNG NAM',
      'cung': 'TỐN',
      'angle': 135.0,
      'lines': [true, true, false],
    },
    {
      'name': 'CHÁNH NAM',
      'cung': 'LY',
      'angle': 180.0,
      'lines': [true, false, true],
    },
    {
      'name': 'TÂY NAM',
      'cung': 'KHÔN',
      'angle': 225.0,
      'lines': [false, false, false],
    },
    {
      'name': 'CHÁNH TÂY',
      'cung': 'ĐOÀI',
      'angle': 270.0,
      'lines': [false, true, true],
    },
    {
      'name': 'TÂY BẮC',
      'cung': 'CÀN',
      'angle': 315.0,
      'lines': [true, true, true],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final directionMeanings = activeCungPhi != null
        ? BatTrachCalculator.getDirectionMeanings(activeCungPhi!)
        : BatTrachCalculator.getDirectionMeanings(CungPhi.chan);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFAF6EE), // Nền giấy dó ngà ấm mộc mạc
        border: Border.all(color: const Color(0xFF5A4D41), width: 3.0), // Viền gỗ bao quanh
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Nền hình học các vành đồng tâm và màu phân cung (Gỗ, Trắng, Đen)
          CustomPaint(
            size: Size(size, size),
            painter: _MinimalistWoodDialPainter(
              directionMeanings: directionMeanings,
              activeCungPhi: activeCungPhi,
            ),
          ),

          // 2. Vành Vạch Độ Ngoài Cùng (0 - 360 độ)
          for (int deg = 0; deg < 360; deg += 10)
            Transform.rotate(
              angle: deg * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.003),
                  child: Text(
                    '$deg',
                    style: TextStyle(
                      fontSize: size * 0.017,
                      fontWeight: FontWeight.bold,
                      color: deg == 0 ? const Color(0xFF9E2A2B) : const Color(0xFF333333),
                    ),
                  ),
                ),
              ),
            ),

          // 3. Vành 24 Sao Phúc Đức
          for (final pd in BatTrachCalculator.phucDuc24List)
            Transform.rotate(
              angle: (pd['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.046),
                  child: Text(
                    pd['name'],
                    style: TextStyle(
                      fontSize: size * 0.014,
                      fontWeight: FontWeight.w600,
                      color: (pd['isGood'] as bool) ? const Color(0xFF1B4332) : const Color(0xFF7F1D1D),
                    ),
                  ),
                ),
              ),
            ),

          // 4. Vành 8 Cung Bát Trạch (THIÊN Y, LỤC SÁT, v.v.)
          for (int i = 0; i < 8; i++)
            Builder(
              builder: (context) {
                final angle = i * 45.0;
                final meaning = directionMeanings[angle.toInt()];
                final name = meaning?.name ?? '';
                final isGood = meaning?.isGood ?? false;

                return Transform.rotate(
                  angle: angle * (math.pi / 180.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: size * 0.098),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: size * 0.026,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: isGood ? const Color(0xFF7F1D1D) : const Color(0xFFFAF6EE),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // 5. Vành 24 Sơn Hướng (Nhâm, Tý, Quý...)
          for (final son in BatTrachCalculator.son24List)
            Transform.rotate(
              angle: (son['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.168),
                  child: Text(
                    son['name'],
                    style: TextStyle(
                      fontSize: size * 0.020,
                      fontWeight: FontWeight.bold,
                      color: (son['angle'] == 0.0 || son['angle'] == 180.0 || son['angle'] == 90.0 || son['angle'] == 270.0)
                          ? Colors.white
                          : const Color(0xFF1F1D1A),
                    ),
                  ),
                ),
              ),
            ),

          // 6. Vành 8 Hướng Địa Lý (CHÁNH BẮC, ĐÔNG BẮC...)
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.228),
                  child: Text(
                    dir['name'] as String,
                    style: TextStyle(
                      fontSize: size * 0.018,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3E3835),
                    ),
                  ),
                ),
              ),
            ),

          // 7. Vành 8 Cung Mạng Bát Quái (KHẢM, CẤN, CHẤN...)
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.272),
                  child: Text(
                    dir['cung'] as String,
                    style: TextStyle(
                      fontSize: size * 0.026,
                      fontWeight: FontWeight.w900,
                      color: (activeCungPhi != null && dir['cung'] == activeCungPhi!.vietnameseName)
                          ? Colors.white
                          : const Color(0xFF1F1D1A),
                    ),
                  ),
                ),
              ),
            ),

          // 8. Vành 8 Quẻ Hào Bát Quái (Vạch đen mực mộc bản)
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.320),
                  child: _TrigramLinesWidget(
                    lines: dir['lines'] as List<bool>,
                    width: size * 0.088,
                    lineHeight: size * 0.009,
                    spacing: size * 0.004,
                  ),
                ),
              ),
            ),

          // 9. Tâm La Bàn: Thái Cực Âm Dương Tông Gỗ Mộc
          Container(
            width: size * 0.21,
            height: size * 0.21,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFAF6EE),
              border: Border.all(color: const Color(0xFF5A4D41), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(size * 0.20, size * 0.20),
                  painter: _WoodYinYangPainter(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF6EE).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF5A4D41), width: 0.8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TRƯỚC',
                        style: TextStyle(
                          fontSize: size * 0.019,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E1A17),
                        ),
                      ),
                      Container(height: 1, width: size * 0.08, color: const Color(0xFF8D7B68)),
                      Text(
                        'SAU',
                        style: TextStyle(
                          fontSize: size * 0.019,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF9E2A2B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrigramLinesWidget extends StatelessWidget {
  final List<bool> lines;
  final double width;
  final double lineHeight;
  final double spacing;

  const _TrigramLinesWidget({
    required this.lines,
    required this.width,
    required this.lineHeight,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    const lineColor = Color(0xFF1C1A18); // Màu mực đen gỗ mộc

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: lines.map((isSolid) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: spacing / 2),
          child: isSolid
              ? Container(
                  width: width,
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: (width - 3) / 2,
                      height: lineHeight,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      width: (width - 3) / 2,
                      height: lineHeight,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                    ),
                  ],
                ),
        );
      }).toList(),
    );
  }
}

class _MinimalistWoodDialPainter extends CustomPainter {
  final Map<int, BatTrachDirectionType> directionMeanings;
  final CungPhi? activeCungPhi;

  _MinimalistWoodDialPainter({
    required this.directionMeanings,
    this.activeCungPhi,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final R = size.width / 2;

    final rVachDo = R;                     // 1.00
    final rPhucDuc = R * 0.91;             // 0.91
    final rBatTrach = R * 0.82;            // 0.82
    final rSon24 = R * 0.65;               // 0.65
    final rHuongDiaLy = R * 0.53;          // 0.53
    final rCungMang = R * 0.44;            // 0.44
    final rHaoQue = R * 0.35;              // 0.35
    final rTam = R * 0.21;                 // 0.21

    // 1. TÔ MÀU VÀNH BÁT TRẠCH (Cát = Gỗ ngà sáng #EFE6D5 / Hung = Gỗ mun đen #2B2825)
    for (int i = 0; i < 8; i++) {
      final angleCenter = i * 45.0;
      final startAngleRad = (angleCenter - 22.5 - 90.0) * (math.pi / 180.0);
      final sweepAngleRad = 45.0 * (math.pi / 180.0);
      final meaning = directionMeanings[angleCenter.toInt()];
      final isGood = meaning?.isGood ?? false;

      final sectorPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isGood
            ? const Color(0xFFEFE6D5) // Nền gỗ ngà ấm cho Cát
            : const Color(0xFF2B2825); // Nền gỗ mun sẫm cho Hung

      final path = Path()
        ..arcTo(Rect.fromCircle(center: center, radius: rPhucDuc), startAngleRad, sweepAngleRad, false)
        ..arcTo(Rect.fromCircle(center: center, radius: rBatTrach), startAngleRad + sweepAngleRad, -sweepAngleRad, false)
        ..close();
      canvas.drawPath(path, sectorPaint);
    }

    // 2. TÔ MÀU VÀNH 24 SƠN HƯỚNG
    for (int i = 0; i < 24; i++) {
      final son = BatTrachCalculator.son24List[i];
      final angle = son['angle'] as double;
      final startAngleRad = (angle - 7.5 - 90.0) * (math.pi / 180.0);
      final sweepAngleRad = 15.0 * (math.pi / 180.0);

      final isCardinalMajor = (angle == 0.0 || angle == 180.0 || angle == 90.0 || angle == 270.0);

      final sonPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isCardinalMajor
            ? const Color(0xFF8D2817) // Đỏ chu sa trầm điểm nhấn cho Tý, Ngọ, Mão, Dậu
            : const Color(0xFFF7F3EA); // Giấy ngà tự nhiên

      final path = Path()
        ..arcTo(Rect.fromCircle(center: center, radius: rBatTrach), startAngleRad, sweepAngleRad, false)
        ..arcTo(Rect.fromCircle(center: center, radius: rSon24), startAngleRad + sweepAngleRad, -sweepAngleRad, false)
        ..close();
      canvas.drawPath(path, sonPaint);
    }

    // 3. TÔ MÀU VÀNH 8 HƯỚNG ĐỊA LÝ (Màu gỗ xám ngà tối giản)
    final huongBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFE8E2D5);

    final huongPath = Path()
      ..arcTo(Rect.fromCircle(center: center, radius: rSon24), 0, 2 * math.pi, false)
      ..arcTo(Rect.fromCircle(center: center, radius: rCungMang), 2 * math.pi, -2 * math.pi, false)
      ..close();
    canvas.drawPath(huongPath, huongBgPaint);

    // Điểm nhấn Cung Bản Mệnh của gia chủ
    if (activeCungPhi != null) {
      double cungAngle = 90.0;
      switch (activeCungPhi!) {
        case CungPhi.kham: cungAngle = 0.0; break;
        case CungPhi.canTho: cungAngle = 45.0; break;
        case CungPhi.chan: cungAngle = 90.0; break;
        case CungPhi.ton: cungAngle = 135.0; break;
        case CungPhi.ly: cungAngle = 180.0; break;
        case CungPhi.khon: cungAngle = 225.0; break;
        case CungPhi.doai: cungAngle = 270.0; break;
        case CungPhi.canKim: cungAngle = 315.0; break;
      }
      final cungStartRad = (cungAngle - 22.5 - 90.0) * (math.pi / 180.0);
      final cungPath = Path()
        ..arcTo(Rect.fromCircle(center: center, radius: rSon24), cungStartRad, 45.0 * (math.pi / 180.0), false)
        ..arcTo(Rect.fromCircle(center: center, radius: rHaoQue), cungStartRad + 45.0 * (math.pi / 180.0), -45.0 * (math.pi / 180.0), false)
        ..close();
      final cungPaint = Paint()..color = const Color(0xFF8D2817);
      canvas.drawPath(cungPath, cungPaint);
    }

    // 4. CÁC ĐƯỜNG VIỀN KHẮC GỖ (Nâu mực ấm)
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF5A4D41)
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, rVachDo - 1, ringPaint);
    canvas.drawCircle(center, rPhucDuc, ringPaint);
    canvas.drawCircle(center, rBatTrach, ringPaint);
    canvas.drawCircle(center, rSon24, ringPaint);
    canvas.drawCircle(center, rHuongDiaLy, ringPaint);
    canvas.drawCircle(center, rCungMang, ringPaint);
    canvas.drawCircle(center, rHaoQue, ringPaint);
    canvas.drawCircle(center, rTam, ringPaint);

    // 5. VẠCH ĐỘ
    final tickRed = Paint()..color = const Color(0xFF8D2817)..strokeWidth = 1.0;
    final tickDark = Paint()..color = const Color(0xFF5A4D41)..strokeWidth = 0.6;

    for (int deg = 0; deg < 360; deg++) {
      final rad = deg * (math.pi / 180.0) - math.pi / 2;
      final isMajor = (deg % 10 == 0);
      final isFive = (deg % 5 == 0);
      final tickLength = isMajor ? 8.0 : (isFive ? 5.5 : 3.0);
      final p1 = Offset(center.dx + rVachDo * math.cos(rad), center.dy + rVachDo * math.sin(rad));
      final p2 = Offset(center.dx + (rVachDo - tickLength) * math.cos(rad), center.dy + (rVachDo - tickLength) * math.sin(rad));
      canvas.drawLine(p1, p2, isMajor || isFive ? tickRed : tickDark);
    }

    // 6. ĐƯỜNG PHÂN CUNG MỘC BẢN
    final linePaintDark = Paint()..color = const Color(0xFF5A4D41)..strokeWidth = 0.8;
    for (int i = 0; i < 8; i++) {
      final rad = (i * 45.0 + 22.5 - 90.0) * (math.pi / 180.0);
      final p1 = Offset(center.dx + rPhucDuc * math.cos(rad), center.dy + rPhucDuc * math.sin(rad));
      final p2 = Offset(center.dx + rTam * math.cos(rad), center.dy + rTam * math.sin(rad));
      canvas.drawLine(p1, p2, linePaintDark);
    }

    final linePaintThin = Paint()..color = const Color(0xFF5A4D41).withOpacity(0.5)..strokeWidth = 0.6;
    for (int i = 0; i < 24; i++) {
      final rad = (i * 15.0 + 7.5 - 90.0) * (math.pi / 180.0);
      final p1 = Offset(center.dx + rBatTrach * math.cos(rad), center.dy + rBatTrach * math.sin(rad));
      final p2 = Offset(center.dx + rSon24 * math.cos(rad), center.dy + rSon24 * math.sin(rad));
      canvas.drawLine(p1, p2, linePaintThin);
    }
  }

  @override
  bool shouldRepaint(covariant _MinimalistWoodDialPainter oldDelegate) =>
      oldDelegate.activeCungPhi != activeCungPhi;
}

class _WoodYinYangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Nửa gỗ sáng đàn hương
    final woodLight = Paint()..color = const Color(0xFFC49A6C);
    // Nửa gỗ sẫm mun đen
    final woodDark = Paint()..color = const Color(0xFF1E1A17);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, math.pi, true, woodDark);
    canvas.drawArc(rect, math.pi / 2, math.pi, true, woodLight);

    final topSubCircleCenter = Offset(center.dx, center.dy - radius / 2);
    final bottomSubCircleCenter = Offset(center.dx, center.dy + radius / 2);

    canvas.drawCircle(topSubCircleCenter, radius / 2, woodLight);
    canvas.drawCircle(bottomSubCircleCenter, radius / 2, woodDark);

    canvas.drawCircle(topSubCircleCenter, radius * 0.12, woodDark);
    canvas.drawCircle(bottomSubCircleCenter, radius * 0.12, woodLight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
