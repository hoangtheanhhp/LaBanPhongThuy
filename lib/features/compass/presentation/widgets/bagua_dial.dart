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

  /// 8 Cung Bát Quái Tiên Thiên / Hậu Thiên theo phương vị la bàn
  /// (Góc 0°: Bắc/Khảm, 45°: ĐB/Cấn, 90°: Đông/Chấn, 135°: ĐN/Tốn, 180°: Nam/Ly, 225°: TN/Khôn, 270°: Tây/Đoài, 315°: TB/Càn)
  static const List<Map<String, dynamic>> bagua8Directions = [
    {
      'name': 'CHÁNH BẮC',
      'cung': 'KHẢM',
      'angle': 0.0,
      // Quẻ Khảm: Âm - Dương - Âm (trên đứt, giữa liền, dưới đứt)
      'lines': [false, true, false],
    },
    {
      'name': 'ĐÔNG BẮC',
      'cung': 'CẤN',
      'angle': 45.0,
      // Quẻ Cấn: Dương - Âm - Âm (trên liền, giữa đứt, dưới đứt)
      'lines': [true, false, false],
    },
    {
      'name': 'CHÁNH ĐÔNG',
      'cung': 'CHẤN',
      'angle': 90.0,
      // Quẻ Chấn: Âm - Âm - Dương (trên đứt, giữa đứt, dưới liền)
      'lines': [false, false, true],
    },
    {
      'name': 'ĐÔNG NAM',
      'cung': 'TỐN',
      'angle': 135.0,
      // Quẻ Tốn: Dương - Dương - Âm (trên liền, giữa liền, dưới đứt)
      'lines': [true, true, false],
    },
    {
      'name': 'CHÁNH NAM',
      'cung': 'LY',
      'angle': 180.0,
      // Quẻ Ly: Dương - Âm - Dương (trên liền, giữa đứt, dưới liền)
      'lines': [true, false, true],
    },
    {
      'name': 'TÂY NAM',
      'cung': 'KHÔN',
      'angle': 225.0,
      // Quẻ Khôn: Âm - Âm - Âm (3 hào đứt)
      'lines': [false, false, false],
    },
    {
      'name': 'CHÁNH TÂY',
      'cung': 'ĐOÀI',
      'angle': 270.0,
      // Quẻ Đoài: Âm - Dương - Dương (trên đứt, 2 hào liền)
      'lines': [false, true, true],
    },
    {
      'name': 'TÂY BẮC',
      'cung': 'CÀN',
      'angle': 315.0,
      // Quẻ Càn: Dương - Dương - Dương (3 hào liền)
      'lines': [true, true, true],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final directionMeanings = activeCungPhi != null
        ? BatTrachCalculator.getDirectionMeanings(activeCungPhi!)
        : BatTrachCalculator.getDirectionMeanings(CungPhi.chan); // Mặc định Chấn (như ảnh 1997)

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 18,
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
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    '$deg',
                    style: TextStyle(
                      fontSize: size * 0.021,
                      fontWeight: FontWeight.bold,
                      color: deg == 0 ? Colors.red : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

          // 3. Vành 24 Sao Phúc Đức (Phước Đức / Tấn Tài / Bại Tuyệt...)
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
                      fontSize: size * 0.016,
                      fontWeight: FontWeight.w700,
                      color: (pd['isGood'] as bool) ? const Color(0xFF006600) : const Color(0xFF990000),
                    ),
                  ),
                ),
              ),
            ),

          // 4. Vành 8 Cung Bát Trạch (THIÊN Y, LỤC SÁT, PHỤC VỊ, v.v.)
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
                      padding: EdgeInsets.only(top: size * 0.092),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: size * 0.038,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: isGood
                              ? (angle == 0 || angle == 180 ? Colors.red.shade900 : const Color(0xFFB30000))
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // 5. Vành 24 Sơn Hướng (Nhâm, Tý, Quý, Sửu, Cấn, Dần...)
          for (final son in BatTrachCalculator.son24List)
            Transform.rotate(
              angle: (son['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.170),
                  child: Text(
                    son['name'],
                    style: TextStyle(
                      fontSize: size * 0.027,
                      fontWeight: FontWeight.bold,
                      color: (son['angle'] == 0.0 || son['angle'] == 180.0 || son['angle'] == 90.0 || son['angle'] == 270.0)
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),

          // 6. Vành 8 Hướng Địa Lý (CHÁNH BẮC, ĐÔNG BẮC, CHÁNH ĐÔNG...)
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.232),
                  child: Text(
                    dir['name'] as String,
                    style: TextStyle(
                      fontSize: size * 0.026,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF005500),
                    ),
                  ),
                ),
              ),
            ),

          // 7. Vành 8 Cung Mạng Bát Quái (KHẢM, CẤN, CHẤN, TỐN, LY, KHÔN, ĐOÀI, CÀN)
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.274),
                  child: Text(
                    dir['cung'] as String,
                    style: TextStyle(
                      fontSize: size * 0.034,
                      fontWeight: FontWeight.w900,
                      color: dir['angle'] == 90.0 ? Colors.white : const Color(0xFF0033CC),
                    ),
                  ),
                ),
              ),
            ),

          // 8. Vành 8 Quẻ Hào Bát Quái (Hào Âm --  --, Hào Dương —— màu đỏ rực như ảnh)
          for (final dir in bagua8Directions)
            Transform.rotate(
              angle: (dir['angle'] as double) * (math.pi / 180.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: size * 0.320),
                  child: _TrigramLinesWidget(
                    lines: dir['lines'] as List<bool>,
                    width: size * 0.115,
                    lineHeight: size * 0.012,
                    spacing: size * 0.005,
                  ),
                ),
              ),
            ),

          // 9. Tâm La Bàn: Thái Cực (Âm Dương Hoàng Đạo) + Kim Chỉ Nam / Hướng TRƯỚC - SAU
          Container(
            width: size * 0.22,
            height: size * 0.22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFF888888), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Biểu tượng Thái Cực Âm Dương (Xanh lá & Vàng như bản vẽ truyền thống)
                CustomPaint(
                  size: Size(size * 0.21, size * 0.21),
                  painter: _YinYangPainter(),
                ),
                // Khối TRƯỚC / SAU trung tâm
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blueGrey, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TRƯỚC',
                        style: TextStyle(
                          fontSize: size * 0.022,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0044CC),
                        ),
                      ),
                      Container(height: 1, width: size * 0.10, color: Colors.grey),
                      Text(
                        'SAU',
                        style: TextStyle(
                          fontSize: size * 0.022,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFCC0000),
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

/// Widget vẽ 3 vạch hào Quẻ Bát Quái (Hào Âm = 2 đoạn ngắt quãng, Hào Dương = 1 đoạn liền mạch)
class _TrigramLinesWidget extends StatelessWidget {
  final List<bool> lines; // true = hào dương (liền), false = hào âm (đứt)
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
    const lineColor = Color(0xFFEE0000); // Đỏ rực truyền thống

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: lines.map((isSolid) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: spacing / 2),
          child: isSolid
              // Hào Dương: Thanh liền
              ? Container(
                  width: width,
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                )
              // Hào Âm: 2 thanh ngắt quãng ở giữa
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: (width - 4) / 2,
                      height: lineHeight,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: (width - 4) / 2,
                      height: lineHeight,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ],
                ),
        );
      }).toList(),
    );
  }
}

/// Painter vẽ toàn bộ các vành khuyên đồng tâm và màu sắc cung Bát Trạch
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

    // Định nghĩa bán kính các vành từ ngoài vào trong:
    final rVachDo = R;                     // 1.00 - Vạch độ ngoài cùng
    final rPhucDuc = R * 0.90;             // 0.90 - Vành 24 Phúc Đức
    final rBatTrach = R * 0.81;            // 0.81 - Vành Bát Trạch (Thiên Y, Sinh Khí...)
    final rSon24 = R * 0.65;               // 0.65 - Vành 24 Sơn Hướng
    final rHuongDiaLy = R * 0.52;          // 0.52 - Vành 8 Hướng Địa lý (Chánh Bắc, Đông Bắc...)
    final rCungMang = R * 0.44;            // 0.44 - Vành 8 Cung (Khảm, Cấn, Chấn...)
    final rHaoQue = R * 0.36;              // 0.36 - Vành Quẻ Hào
    final rTam = R * 0.22;                 // 0.22 - Tâm Thái Cực

    // --- 1. TÔ MÀU VÀNH BÁT TRẠCH (4 CUNG CÁT = VÀNG / 4 CUNG HUNG = XANH ĐẬM / ĐEN) ---
    for (int i = 0; i < 8; i++) {
      final angleCenter = i * 45.0;
      final startAngleRad = (angleCenter - 22.5 - 90.0) * (math.pi / 180.0);
      final sweepAngleRad = 45.0 * (math.pi / 180.0);
      final meaning = directionMeanings[angleCenter.toInt()];
      final isGood = meaning?.isGood ?? false;

      final sectorPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isGood
            ? const Color(0xFFFFF275) // Vàng tươi cung Cát như ảnh mẫu
            : const Color(0xFF004D20); // Xanh lá đậm / Đen cung Hung như ảnh mẫu

      final path = Path()
        ..arcTo(Rect.fromCircle(center: center, radius: rPhucDuc), startAngleRad, sweepAngleRad, false)
        ..arcTo(Rect.fromCircle(center: center, radius: rBatTrach), startAngleRad + sweepAngleRad, -sweepAngleRad, false)
        ..close();
      canvas.drawPath(path, sectorPaint);
    }

    // --- 2. TÔ MÀU VÀNH 24 SƠN HƯỚNG ---
    for (int i = 0; i < 24; i++) {
      final son = BatTrachCalculator.son24List[i];
      final angle = son['angle'] as double;
      final startAngleRad = (angle - 7.5 - 90.0) * (math.pi / 180.0);
      final sweepAngleRad = 15.0 * (math.pi / 180.0);

      // Điểm nhấn 4 chính cung (Tý=Bắc, Ngọ=Nam, Mão=Đông, Dậu=Tây): màu đỏ rực
      final isCardinalMajor = (angle == 0.0 || angle == 180.0 || angle == 90.0 || angle == 270.0);

      final sonPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isCardinalMajor
            ? const Color(0xFFE50914) // Đỏ tươi
            : Colors.white;

      final path = Path()
        ..arcTo(Rect.fromCircle(center: center, radius: rBatTrach), startAngleRad, sweepAngleRad, false)
        ..arcTo(Rect.fromCircle(center: center, radius: rSon24), startAngleRad + sweepAngleRad, -sweepAngleRad, false)
        ..close();
      canvas.drawPath(path, sonPaint);
    }

    // --- 3. TÔ MÀU VÀNH 8 HƯỚNG ĐỊA LÝ (XANH NHẠT NHƯ ẢNH MẪU) ---
    final huongBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFE8F5E9); // Xanh cốm nhạt

    final huongPath = Path()
      ..arcTo(Rect.fromCircle(center: center, radius: rSon24), 0, 2 * math.pi, false)
      ..arcTo(Rect.fromCircle(center: center, radius: rCungMang), 2 * math.pi, -2 * math.pi, false)
      ..close();
    canvas.drawPath(huongPath, huongBgPaint);

    // Điểm nhấn cung bản mệnh (ví dụ Chấn tuổi 1997 được tô nền đỏ nổi bật như ảnh)
    final chanStartAngleRad = (90.0 - 22.5 - 90.0) * (math.pi / 180.0);
    final chanPath = Path()
      ..arcTo(Rect.fromCircle(center: center, radius: rSon24), chanStartAngleRad, 45.0 * (math.pi / 180.0), false)
      ..arcTo(Rect.fromCircle(center: center, radius: rHaoQue), chanStartAngleRad + 45.0 * (math.pi / 180.0), -45.0 * (math.pi / 180.0), false)
      ..close();
    final chanPaint = Paint()..color = const Color(0xFFE50914);
    canvas.drawPath(chanPath, chanPaint);

    // --- 4. VẼ CÁC VÒNG TRÒN PHÂN ĐỊNH RANH GIỚI ---
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF0033CC) // Đường viền xanh dương truyền thống
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, rVachDo - 1, ringPaint);
    canvas.drawCircle(center, rPhucDuc, ringPaint);
    canvas.drawCircle(center, rBatTrach, ringPaint);
    canvas.drawCircle(center, rSon24, ringPaint);
    canvas.drawCircle(center, rHuongDiaLy, ringPaint);
    canvas.drawCircle(center, rCungMang, ringPaint);
    canvas.drawCircle(center, rHaoQue, ringPaint);
    canvas.drawCircle(center, rTam, ringPaint);

    // --- 5. VẼ CÁC VẠCH ĐỘ NGOÀI CÙNG (360 ĐỘ) ---
    final tickRed = Paint()..color = Colors.red..strokeWidth = 1.2;
    final tickBlack = Paint()..color = Colors.black87..strokeWidth = 0.8;

    for (int deg = 0; deg < 360; deg++) {
      final rad = deg * (math.pi / 180.0) - math.pi / 2;
      final isMajor = (deg % 10 == 0);
      final isFive = (deg % 5 == 0);
      final tickLength = isMajor ? 9.0 : (isFive ? 6.0 : 3.5);
      final p1 = Offset(center.dx + rVachDo * math.cos(rad), center.dy + rVachDo * math.sin(rad));
      final p2 = Offset(center.dx + (rVachDo - tickLength) * math.cos(rad), center.dy + (rVachDo - tickLength) * math.sin(rad));
      canvas.drawLine(p1, p2, isMajor || isFive ? tickRed : tickBlack);
    }

    // --- 6. VẼ CÁC ĐƯỜNG PHÂN CUNG (8 CUNG & 24 SƠN) ---
    final linePaintBlue = Paint()..color = const Color(0xFF0033CC)..strokeWidth = 1.0;

    for (int i = 0; i < 8; i++) {
      final rad = (i * 45.0 + 22.5 - 90.0) * (math.pi / 180.0);
      final p1 = Offset(center.dx + rPhucDuc * math.cos(rad), center.dy + rPhucDuc * math.sin(rad));
      final p2 = Offset(center.dx + rTam * math.cos(rad), center.dy + rTam * math.sin(rad));
      canvas.drawLine(p1, p2, linePaintBlue);
    }

    // 24 Sơn vạch ngắn ở vành sơn
    final linePaintThin = Paint()..color = const Color(0xFF0033CC).withOpacity(0.5)..strokeWidth = 0.8;
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

/// Vẽ Thái Cực Âm Dương Hoàng Đạo
class _YinYangPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Nửa Vàng
    final yellowPaint = Paint()..color = const Color(0xFFFFD700);
    // Nửa Xanh lá phong thuỷ
    final greenPaint = Paint()..color = const Color(0xFF006622);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, math.pi, true, greenPaint);
    canvas.drawArc(rect, math.pi / 2, math.pi, true, yellowPaint);

    // Hai hình tròn nội tiếp tạo thành đường cong S Âm Dương
    final topSubCircleCenter = Offset(center.dx, center.dy - radius / 2);
    final bottomSubCircleCenter = Offset(center.dx, center.dy + radius / 2);

    canvas.drawCircle(topSubCircleCenter, radius / 2, yellowPaint);
    canvas.drawCircle(bottomSubCircleCenter, radius / 2, greenPaint);

    // Mắt Thái Cực
    canvas.drawCircle(topSubCircleCenter, radius * 0.12, greenPaint);
    canvas.drawCircle(bottomSubCircleCenter, radius * 0.12, yellowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
