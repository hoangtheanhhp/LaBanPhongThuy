import 'dart:math' as math;
import 'package:flutter/material.dart';
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Toàn bộ hình học nền, vành khuyên và các phân cung màu
          CustomPaint(
            size: Size(size, size),
            painter: _FullLaBanPainter(
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
                  padding: EdgeInsets.only(top: size * 0.002),
                  child: Text(
                    '$deg',
                    style: TextStyle(
                      fontSize: size * 0.018, // Giảm cỡ chữ vừa khít vành
                      fontWeight: FontWeight.bold,
                      color: deg == 0 ? Colors.red : Colors.black87,
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
                  padding: EdgeInsets.only(top: size * 0.045),
                  child: Text(
                    pd['name'],
                    style: TextStyle(
                      fontSize: size * 0.0145, // Cỡ chữ nhỏ gọn tinh tế
                      fontWeight: FontWeight.w700,
                      color: (pd['isGood'] as bool) ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
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
                      padding: EdgeInsets.only(top: size * 0.098), // Đặt chuẩn xác giữa vành
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: size * 0.027, // Cỡ chữ vừa vặn hoàn hảo trong khung màu
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                          color: isGood ? const Color(0xFFB71C1C) : Colors.white,
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
                      fontSize: size * 0.021, // Nhỏ gọn vừa ô sơn
                      fontWeight: FontWeight.bold,
                      color: (son['angle'] == 0.0 || son['angle'] == 180.0 || son['angle'] == 90.0 || son['angle'] == 270.0)
                          ? Colors.white
                          : const Color(0xFF212121),
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
                      fontSize: size * 0.019, // Chữ thanh lịch không lấn cung
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B5E20),
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
                          : const Color(0xFF0D47A1),
                    ),
                  ),
                ),
              ),
            ),

          // 8. Vành 8 Quẻ Hào Bát Quái
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.320),
                  child: _TrigramLinesWidget(
                    lines: dir['lines'] as List<bool>,
                    width: size * 0.090,
                    lineHeight: size * 0.009,
                    spacing: size * 0.004,
                  ),
                ),
              ),
            ),

          // 9. Tâm La Bàn: Thái Cực Âm Dương & Khối TRƯỚC - SAU
          Container(
            width: size * 0.21,
            height: size * 0.21,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFF757575), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(size * 0.20, size * 0.20),
                  painter: _YinYangPainter(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFB0BEC5), width: 0.8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TRƯỚC',
                        style: TextStyle(
                          fontSize: size * 0.020,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D47A1),
                        ),
                      ),
                      Container(height: 1, width: size * 0.08, color: Colors.grey.shade400),
                      Text(
                        'SAU',
                        style: TextStyle(
                          fontSize: size * 0.020,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC62828),
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
    const lineColor = Color(0xFFD32F2F);

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

class _FullLaBanPainter extends CustomPainter {
  final Map<int, BatTrachDirectionType> directionMeanings;
  final CungPhi? activeCungPhi;

  _FullLaBanPainter({
    required this.directionMeanings,
    this.activeCungPhi,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final R = size.width / 2;

    // Bán kính chuẩn hóa
    final rVachDo = R;                     // 1.00
    final rPhucDuc = R * 0.91;             // 0.91
    final rBatTrach = R * 0.82;            // 0.82
    final rSon24 = R * 0.65;               // 0.65
    final rHuongDiaLy = R * 0.53;          // 0.53
    final rCungMang = R * 0.44;            // 0.44
    final rHaoQue = R * 0.35;              // 0.35
    final rTam = R * 0.21;                 // 0.21

    // 1. TÔ MÀU VÀNH BÁT TRẠCH (Màu trang nhã, tương phản cao, dễ nhìn)
    for (int i = 0; i < 8; i++) {
      final angleCenter = i * 45.0;
      final startAngleRad = (angleCenter - 22.5 - 90.0) * (math.pi / 180.0);
      final sweepAngleRad = 45.0 * (math.pi / 180.0);
      final meaning = directionMeanings[angleCenter.toInt()];
      final isGood = meaning?.isGood ?? false;

      final sectorPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isGood
            ? const Color(0xFFFFF3B0) // Vàng kem hoàng đạo dịu mắt, tương phản cao
            : const Color(0xFF1B4332); // Xanh lục sẫm sang trọng

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
            ? const Color(0xFFE50914) // Đỏ son chủ cung
            : Colors.white;

      final path = Path()
        ..arcTo(Rect.fromCircle(center: center, radius: rBatTrach), startAngleRad, sweepAngleRad, false)
        ..arcTo(Rect.fromCircle(center: center, radius: rSon24), startAngleRad + sweepAngleRad, -sweepAngleRad, false)
        ..close();
      canvas.drawPath(path, sonPaint);
    }

    // 3. TÔ MÀU VÀNH 8 HƯỚNG ĐỊA LÝ
    final huongBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFE8F5E9); // Xanh cốm nhạt

    final huongPath = Path()
      ..arcTo(Rect.fromCircle(center: center, radius: rSon24), 0, 2 * math.pi, false)
      ..arcTo(Rect.fromCircle(center: center, radius: rCungMang), 2 * math.pi, -2 * math.pi, false)
      ..close();
    canvas.drawPath(huongPath, huongBgPaint);

    // Tô nền nổi bật cho Cung Bản Mệnh của người dùng
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
      final cungPaint = Paint()..color = const Color(0xFFE50914);
      canvas.drawPath(cungPath, cungPaint);
    }

    // 4. VÒNG TRÒN PHÂN ĐỊNH (Viền xanh dương đậm tao nhã)
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, rVachDo - 1, ringPaint);
    canvas.drawCircle(center, rPhucDuc, ringPaint);
    canvas.drawCircle(center, rBatTrach, ringPaint);
    canvas.drawCircle(center, rSon24, ringPaint);
    canvas.drawCircle(center, rHuongDiaLy, ringPaint);
    canvas.drawCircle(center, rCungMang, ringPaint);
    canvas.drawCircle(center, rHaoQue, ringPaint);
    canvas.drawCircle(center, rTam, ringPaint);

    // 5. VẠCH ĐỘ (360 ĐỘ)
    final tickRed = Paint()..color = const Color(0xFFD32F2F)..strokeWidth = 1.0;
    final tickBlack = Paint()..color = const Color(0xFF424242)..strokeWidth = 0.6;

    for (int deg = 0; deg < 360; deg++) {
      final rad = deg * (math.pi / 180.0) - math.pi / 2;
      final isMajor = (deg % 10 == 0);
      final isFive = (deg % 5 == 0);
      final tickLength = isMajor ? 8.0 : (isFive ? 5.5 : 3.0);
      final p1 = Offset(center.dx + rVachDo * math.cos(rad), center.dy + rVachDo * math.sin(rad));
      final p2 = Offset(center.dx + (rVachDo - tickLength) * math.cos(rad), center.dy + (rVachDo - tickLength) * math.sin(rad));
      canvas.drawLine(p1, p2, isMajor || isFive ? tickRed : tickBlack);
    }

    // 6. ĐƯỜNG PHÂN CUNG
    final linePaintBlue = Paint()..color = const Color(0xFF1565C0)..strokeWidth = 0.8;
    for (int i = 0; i < 8; i++) {
      final rad = (i * 45.0 + 22.5 - 90.0) * (math.pi / 180.0);
      final p1 = Offset(center.dx + rPhucDuc * math.cos(rad), center.dy + rPhucDuc * math.sin(rad));
      final p2 = Offset(center.dx + rTam * math.cos(rad), center.dy + rTam * math.sin(rad));
      canvas.drawLine(p1, p2, linePaintBlue);
    }

    final linePaintThin = Paint()..color = const Color(0xFF1565C0).withOpacity(0.5)..strokeWidth = 0.6;
    for (int i = 0; i < 24; i++) {
      final rad = (i * 15.0 + 7.5 - 90.0) * (math.pi / 180.0);
      final p1 = Offset(center.dx + rBatTrach * math.cos(rad), center.dy + rBatTrach * math.sin(rad));
      final p2 = Offset(center.dx + rSon24 * math.cos(rad), center.dy + rSon24 * math.sin(rad));
      canvas.drawLine(p1, p2, linePaintThin);
    }
  }

  @override
  bool shouldRepaint(covariant _FullLaBanPainter oldDelegate) =>
      oldDelegate.activeCungPhi != activeCungPhi;
}

class _YinYangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final yellowPaint = Paint()..color = const Color(0xFFFFD700);
    final greenPaint = Paint()..color = const Color(0xFF1B5E20);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, math.pi, true, greenPaint);
    canvas.drawArc(rect, math.pi / 2, math.pi, true, yellowPaint);

    final topSubCircleCenter = Offset(center.dx, center.dy - radius / 2);
    final bottomSubCircleCenter = Offset(center.dx, center.dy + radius / 2);

    canvas.drawCircle(topSubCircleCenter, radius / 2, yellowPaint);
    canvas.drawCircle(bottomSubCircleCenter, radius / 2, greenPaint);

    canvas.drawCircle(topSubCircleCenter, radius * 0.12, greenPaint);
    canvas.drawCircle(bottomSubCircleCenter, radius * 0.12, yellowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
