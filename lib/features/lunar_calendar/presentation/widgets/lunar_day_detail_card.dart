import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/lunar_calculator.dart';

class LunarDayDetailCard extends StatelessWidget {
  final LunarDate lunarDate;
  final DateTime selectedDate;

  const LunarDayDetailCard({
    super.key,
    required this.lunarDate,
    required this.selectedDate,
  });

  static const List<String> _weekDays = [
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
  ];

  @override
  Widget build(BuildContext context) {
    final weekDayName = _weekDays[selectedDate.weekday - 1];
    final isHoangDao = lunarDate.isHoangDao;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.woodBorder.withOpacity(0.35)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Ngày Dương & Ngày Âm ───────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hộp số ngày to nổi bật
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.woodAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.woodAccent.withOpacity(0.4)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${selectedDate.day}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.woodAccent,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'Th.${selectedDate.month}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Thông tin ngày âm & thứ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          weekDayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ivoryWhite,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge Hoàng Đạo / Hắc Đạo
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isHoangDao
                                ? const Color(0xFFE53935).withOpacity(0.2)
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isHoangDao
                                  ? const Color(0xFFE53935)
                                  : Colors.white24,
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            isHoangDao ? 'HOÀNG ĐẠO' : 'HẮC ĐẠO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isHoangDao ? const Color(0xFFE57373) : Colors.white60,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Âm lịch: ${lunarDate.fullLunarText}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFC49A6C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sao: ${lunarDate.hoangDaoStar} · Tiết ${lunarDate.tietKhi}',
                      style: const TextStyle(fontSize: 11.5, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AppColors.woodBorder, height: 1, thickness: 0.4),
          const SizedBox(height: 12),

          // ── Ba Trụ Can Chi ───────────────────────────────────
          Row(
            children: [
              _CanChiPill('Ngày', lunarDate.canChiDay),
              const SizedBox(width: 8),
              _CanChiPill('Tháng', lunarDate.canChiMonth),
              const SizedBox(width: 8),
              _CanChiPill('Năm', lunarDate.canChiYear),
            ],
          ),

          const SizedBox(height: 12),

          // ── 12 Trực ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF161514),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.woodBorder.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_outlined, color: AppColors.woodAccent, size: 16),
                const SizedBox(width: 8),
                const Text('Trực: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                Expanded(
                  child: Text(
                    lunarDate.truc,
                    style: const TextStyle(
                      color: AppColors.ivoryWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Giờ Hoàng Đạo ────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.woodAccent, size: 15),
                  SizedBox(width: 6),
                  Text(
                    'Giờ Hoàng Đạo:',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ivoryWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: lunarDate.hoangDaoHours.map((h) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.woodAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.woodAccent.withOpacity(0.3)),
                    ),
                    child: Text(
                      h,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.woodAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Hướng Xuất Hành & Tuổi Xung ───────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161514),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.woodBorder.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hướng Xuất Hành',
                          style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Hỷ Thần: ${lunarDate.hyThanDirection}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                      Text('Tài Thần: ${lunarDate.taiThanDirection}',
                          style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161514),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.woodBorder.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tuổi Xung Khắc',
                          style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        lunarDate.xungTuoi,
                        style: const TextStyle(color: Color(0xFFE57373), fontSize: 11.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Việc Nên Làm & Nên Kiêng ──────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nên làm
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141A14),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green, size: 14),
                          SizedBox(width: 4),
                          Text('NÊN LÀM',
                              style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lunarDate.goodFor.join(', '),
                        style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Kiêng cử
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1414),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.highlight_off, color: Color(0xFFE57373), size: 14),
                          SizedBox(width: 4),
                          Text('NÊN KIÊNG',
                              style: TextStyle(color: Color(0xFFE57373), fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lunarDate.badFor.isNotEmpty ? lunarDate.badFor.join(', ') : 'Không có kiêng kỵ lớn',
                        style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CanChiPill extends StatelessWidget {
  final String label;
  final String value;
  const _CanChiPill(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF161514),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.woodBorder.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9.5)),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.woodAccent,
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
