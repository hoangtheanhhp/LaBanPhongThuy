import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/lunar_calculator.dart';

class LunarDayCell extends StatelessWidget {
  final DateTime date;
  final LunarDate lunarDate;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const LunarDayCell({
    super.key,
    required this.date,
    required this.lunarDate,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Chủ nhật (7) hoặc Thứ 7 (6)
    final isWeekend = date.weekday == DateTime.sunday;
    final isSpecialLunarDay = lunarDate.lunarDay == 1 || lunarDate.lunarDay == 15;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.woodAccent.withOpacity(0.18)
                : (isToday
                    ? const Color(0xFF231F1C)
                    : (isCurrentMonth ? const Color(0xFF1B1917) : const Color(0xFF141312))),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? AppColors.woodAccent
                  : (isToday
                      ? AppColors.woodAccent.withOpacity(0.6)
                      : (isCurrentMonth
                          ? AppColors.woodBorder.withOpacity(0.25)
                          : Colors.white.withOpacity(0.04))),
              width: isSelected ? 1.5 : (isToday ? 1.0 : 0.6),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: Opacity(
            opacity: isCurrentMonth ? 1.0 : 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hàng trên: Ngày Dương (Trái) & Chấm Hoàng Đạo / Hắc Đạo (Phải)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ngày Dương lịch
                    Container(
                      padding: isToday
                          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
                          : EdgeInsets.zero,
                      decoration: isToday
                          ? BoxDecoration(
                              color: AppColors.woodAccent,
                              borderRadius: BorderRadius.circular(4),
                            )
                          : null,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? AppColors.charcoalBlack
                              : (isWeekend ? const Color(0xFFE57373) : AppColors.ivoryWhite),
                        ),
                      ),
                    ),

                    // Chấm Hoàng Đạo (Đỏ/Vàng) hoặc Hắc Đạo (Xám)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 5.5,
                      height: 5.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lunarDate.isHoangDao
                            ? const Color(0xFFE53935) // Chấm đỏ Hoàng Đạo chuẩn ảnh mẫu
                            : const Color(0xFF6E6864), // Chấm xám Hắc Đạo chuẩn ảnh mẫu
                      ),
                    ),
                  ],
                ),

                // Hàng giữa: Ngày Âm lịch (1/12, 15/8, 20...)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    lunarDate.shortLunarText,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSpecialLunarDay ? FontWeight.bold : FontWeight.w600,
                      color: isSpecialLunarDay
                          ? const Color(0xFFE57373) // Mùng 1 & Rằm màu đỏ nổi bật
                          : (isCurrentMonth ? const Color(0xFFC49A6C) : Colors.white38),
                    ),
                  ),
                ),

                // Hàng dưới: Can Chi ngày (Giáp Tý, Ất Sửu...)
                Text(
                  lunarDate.canChiDay,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
                    color: isCurrentMonth ? Colors.white60 : Colors.white24,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
