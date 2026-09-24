import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bat_trach_calculator.dart';
import '../../../../core/utils/compass_math.dart';

/// Panel hiển thị thông tin chi tiết Cung Phi & 8 hướng Bát Trạch
class CungInfoPanel extends StatelessWidget {
  final CungPhi cungPhi;
  final double currentHeading;
  final VoidCallback onDetailTap;

  const CungInfoPanel({
    super.key,
    required this.cungPhi,
    required this.currentHeading,
    required this.onDetailTap,
  });

  static const Map<String, String> _cungSymbol = {
    'KHẢM': '☵', 'CẤN': '☶', 'CHẤN': '☳', 'TỐN': '☴',
    'LY': '☲', 'KHÔN': '☷', 'ĐOÀI': '☱', 'CÀN': '☰',
  };

  static const Map<String, String> _cungMeaning = {
    'KHẢM': 'Trí tuệ · Thích nghi · Kiên nhẫn',
    'CẤN': 'Trung thực · Ổn định · Gia đình',
    'CHẤN': 'Năng động · Tiên phong · Hành động',
    'TỐN': 'Sáng tạo · Giao tiếp · Linh hoạt',
    'LY': 'Danh tiếng · Nghệ thuật · Thông tuệ',
    'KHÔN': 'Nhẫn nại · Bảo vệ · Khiêm tốn',
    'ĐOÀI': 'Ngoại giao · Vui vẻ · Hòa giải',
    'CÀN': 'Lãnh đạo · Quyền lực · Cao thượng',
  };

  static const Map<String, Color> _cungColor = {
    'KHẢM': Color(0xFF1E6091),
    'CẤN': Color(0xFF7B5E2A),
    'CHẤN': Color(0xFF2D6A4F),
    'TỐN': Color(0xFF40916C),
    'LY': Color(0xFF9E2A2B),
    'KHÔN': Color(0xFF6D4C41),
    'ĐOÀI': Color(0xFFB8860B),
    'CÀN': Color(0xFF795548),
  };

  @override
  Widget build(BuildContext context) {
    final meanings = BatTrachCalculator.getDirectionMeanings(cungPhi);
    final currentSector = CompassMath.closestSectorAngle(currentHeading);
    final symbol = _cungSymbol[cungPhi.vietnameseName] ?? '○';
    final meaning = _cungMeaning[cungPhi.vietnameseName] ?? '';
    final cungColor = _cungColor[cungPhi.vietnameseName] ?? AppColors.woodAccent;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.woodBorder.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cungColor.withOpacity(0.15),
                    border: Border.all(color: cungColor.withOpacity(0.4)),
                  ),
                  child: Center(
                    child: Text(symbol,
                        style: TextStyle(fontSize: 22, color: cungColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Cung ${cungPhi.vietnameseName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: cungColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TagBadge(cungPhi.nhom),
                        ],
                      ),
                      Text(
                        '${cungPhi.nguHanh} — $meaning',
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDetailTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.woodAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.info_outline, color: AppColors.woodAccent, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.woodBorder, height: 1, thickness: 0.5),

          // 8 Directions Grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    '8 Phương Vị Bát Trạch',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 8,
                  itemBuilder: (ctx, i) {
                    final sector = i * 45;
                    final m = meanings[sector];
                    if (m == null) return const SizedBox.shrink();
                    final isActive = sector == currentSector;
                    return _DirectionCell(
                      angle: sector,
                      meaning: m,
                      isActive: isActive,
                    );
                  },
                ),
              ],
            ),
          ),

          // Good vs Bad summary bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: _GoodBadBar(meanings: meanings),
          ),
        ],
      ),
    );
  }
}

class _DirectionCell extends StatelessWidget {
  final int angle;
  final BatTrachDirectionType meaning;
  final bool isActive;

  const _DirectionCell({
    required this.angle,
    required this.meaning,
    required this.isActive,
  });

  static const Map<int, String> _compassLabel = {
    0: 'BẮC', 45: 'ĐB', 90: 'ĐÔNG', 135: 'ĐN',
    180: 'NAM', 225: 'TN', 270: 'TÂY', 315: 'TB',
  };

  @override
  Widget build(BuildContext context) {
    final isGood = meaning.isGood;
    final label = _compassLabel[angle] ?? '';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isActive
            ? (isGood
                ? AppColors.woodAccent.withOpacity(0.2)
                : const Color(0xFF3E1A1A))
            : (isGood
                ? const Color(0xFF1C1C14)
                : const Color(0xFF141414)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? (isGood ? AppColors.woodAccent : const Color(0xFF8B2020))
              : AppColors.woodBorder.withOpacity(0.3),
          width: isActive ? 1.5 : 0.8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.white38,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            meaning.name.split(' ').first,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: isGood
                  ? (isActive ? AppColors.woodAccent : const Color(0xFF9C8260))
                  : (isActive ? const Color(0xFFE57373) : const Color(0xFF757575)),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 20,
            height: 3,
            decoration: BoxDecoration(
              color: isGood
                  ? AppColors.woodAccent.withOpacity(isActive ? 0.8 : 0.4)
                  : const Color(0xFF8B2020).withOpacity(isActive ? 0.8 : 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isGood ? 'Cát' : 'Hung',
            style: TextStyle(
              fontSize: 8,
              color: isGood ? Colors.green.shade300 : Colors.red.shade300,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoodBadBar extends StatelessWidget {
  final Map<int, BatTrachDirectionType> meanings;
  const _GoodBadBar({required this.meanings});

  @override
  Widget build(BuildContext context) {
    final good = meanings.values.where((m) => m.isGood).toList();
    final bad = meanings.values.where((m) => !m.isGood).toList();
    final goodNames = good.map((m) => m.name).join(' · ');
    final badNames = bad.map((m) => m.name).join(' · ');

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C14),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.woodAccent.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✦ CÁT (${good.length})',
                    style: const TextStyle(color: AppColors.woodAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(goodNames,
                    style: const TextStyle(color: Colors.white38, fontSize: 9),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF140E0E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF8B2020).withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✦ HUNG (${bad.length})',
                    style: const TextStyle(color: Color(0xFFE57373), fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(badNames,
                    style: const TextStyle(color: Colors.white38, fontSize: 9),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String label;
  const _TagBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.woodBorder.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.woodBorder.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white38, fontSize: 10),
      ),
    );
  }
}
