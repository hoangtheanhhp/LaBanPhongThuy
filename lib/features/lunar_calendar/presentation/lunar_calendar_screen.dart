import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/lunar_calculator.dart';
import 'widgets/lunar_day_cell.dart';
import 'widgets/lunar_day_detail_card.dart';

class LunarCalendarScreen extends StatefulWidget {
  const LunarCalendarScreen({super.key});

  @override
  State<LunarCalendarScreen> createState() => _LunarCalendarScreenState();
}

class _LunarCalendarScreenState extends State<LunarCalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  final DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void _jumpToToday() {
    setState(() {
      _focusedMonth = DateTime(_today.year, _today.month, 1);
      _selectedDate = DateTime(_today.year, _today.month, _today.day);
    });
  }

  void _showMonthYearPicker() {
    int tempYear = _focusedMonth.year;
    int tempMonth = _focusedMonth.month;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chọn Tháng & Năm',
                    style: TextStyle(
                      color: AppColors.woodAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  // Chọn Tháng (1 - 12)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.woodBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: tempMonth,
                          dropdownColor: AppColors.surfaceCard,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          isExpanded: true,
                          items: List.generate(12, (i) => i + 1)
                              .map((m) => DropdownMenuItem(value: m, child: Text('Tháng $m')))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setModalState(() => tempMonth = v);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Chọn Năm (1950 - 2050)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.woodBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: tempYear,
                          dropdownColor: AppColors.surfaceCard,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          isExpanded: true,
                          items: List.generate(101, (i) => 1950 + i)
                              .map((y) => DropdownMenuItem(value: y, child: Text('Năm $y')))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setModalState(() => tempYear = v);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.woodAccent,
                    foregroundColor: AppColors.charcoalBlack,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(tempYear, tempMonth, 1);
                      _selectedDate = DateTime(tempYear, tempMonth, 1);
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Xem Lịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Xây dựng danh sách 35 hoặc 42 ngày cho lưới lịch tháng
  List<DateTime> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;

    // Thứ 2 là 1, CN là 7
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday ... 7 = Sunday
    final leadingDays = firstWeekday - 1;

    final List<DateTime> days = [];

    // Ngày của tháng trước
    for (int i = leadingDays; i > 0; i--) {
      days.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    // Ngày của tháng hiện tại
    for (int i = 0; i < daysInMonth; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, i + 1));
    }

    // Ngày của tháng sau để làm đầy hàng
    final remainingDays = (7 - (days.length % 7)) % 7;
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month + 1, i));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = _buildCalendarDays();
    final selectedLunarDate = LunarCalculator.getFullLunarDate(_selectedDate);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ── 1. Header Bar đỏ chu sa phong cách lịch truyền thống ──
            _buildCalendarHeader(),

            // ── 2. Thanh Thứ trong tuần (Thứ 2 -> C.Nhật) ───────────
            _buildWeekDaysHeader(),

            // ── 3. Danh sách cuộn: Lưới Lịch & Chi Tiết Ngày ────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Lưới lịch tháng
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          childAspectRatio: 0.76, // Tỉ lệ chữ nhật đứng như ảnh mẫu
                        ),
                        itemCount: calendarDays.length,
                        itemBuilder: (context, index) {
                          final day = calendarDays[index];
                          final isCurrentMonth = day.month == _focusedMonth.month;
                          final isToday = day.year == _today.year &&
                              day.month == _today.month &&
                              day.day == _today.day;
                          final isSelected = day.year == _selectedDate.year &&
                              day.month == _selectedDate.month &&
                              day.day == _selectedDate.day;

                          final lunar = LunarCalculator.getFullLunarDate(day);

                          return LunarDayCell(
                            date: day,
                            lunarDate: lunar,
                            isCurrentMonth: isCurrentMonth,
                            isToday: isToday,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                _selectedDate = day;
                                if (day.month != _focusedMonth.month) {
                                  _focusedMonth = DateTime(day.year, day.month, 1);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),

                    // Ghi chú chú thích (Hoàng Đạo, Hắc Đạo)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE53935),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Hoàng đạo', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          const SizedBox(width: 14),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6E6864),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Hắc đạo', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── 4. Bảng Chi Tiết Phong Thủy Ngày Được Chọn ────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: LunarDayDetailCard(
                        selectedDate: _selectedDate,
                        lunarDate: selectedLunarDate,
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Bar chuẩn màu đỏ son phong cách lịch truyền thống như ảnh mẫu
  Widget _buildCalendarHeader() {
    return Container(
      color: AppColors.northRed, // Đỏ chu sa sang trọng
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút tháng trước
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
            tooltip: 'Tháng trước',
            onPressed: _previousMonth,
          ),

          // Tiêu đề: Lịch Âm Tháng M/YYYY (Bấm vào để mở bộ chọn tháng năm)
          GestureDetector(
            onTap: _showMonthYearPicker,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lịch Âm Tháng ${_focusedMonth.month}/${_focusedMonth.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.white, size: 22),
              ],
            ),
          ),

          // Cụm nút: Hôm nay & Tháng sau
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                tooltip: 'Về hôm nay',
                onPressed: _jumpToToday,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
                tooltip: 'Tháng sau',
                onPressed: _nextMonth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Hàng thứ trong tuần: Thứ 2, Thứ 3, Thứ 4, Thứ 5, Thứ 6, Thứ 7, C.Nhật
  Widget _buildWeekDaysHeader() {
    const weekDays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'C.Nhật'];

    return Container(
      color: const Color(0xFF1E1C1A),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: weekDays.map((name) {
          final isSunday = name == 'C.Nhật';
          return Expanded(
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSunday ? const Color(0xFFE57373) : Colors.white70,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
