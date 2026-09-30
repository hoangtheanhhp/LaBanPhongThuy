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

  /// Modal Xem Tuổi Làm Nhà (Tam Tai, Kim Lâu, Hoang Ốc)
  void _showBuildingAgeModal() {
    int birthYear = 1990;
    int buildYear = _focusedMonth.year;
    BuildingAgeResult? result;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.92,
            expand: false,
            builder: (_, scrollCtrl) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.home_work_rounded, color: AppColors.woodAccent, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Xem Tuổi Làm Nhà',
                            style: TextStyle(
                              color: AppColors.woodAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tra cứu Tam Tai · Kim Lâu · Hoang Ốc cho năm xây nhà',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Năm sinh & Năm xây
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Năm sinh (Dương lịch)',
                                style: TextStyle(color: Colors.white60, fontSize: 11)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.woodBorder),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: birthYear,
                                  dropdownColor: AppColors.surfaceCard,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  isExpanded: true,
                                  items: List.generate(80, (i) => 1945 + i)
                                      .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) setModalState(() => birthYear = v);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Năm xây nhà',
                                style: TextStyle(color: Colors.white60, fontSize: 11)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.woodBorder),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: buildYear,
                                  dropdownColor: AppColors.surfaceCard,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  isExpanded: true,
                                  items: List.generate(30, (i) => 2024 + i)
                                      .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) setModalState(() => buildYear = v);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nút Tra Cứu
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.woodAccent,
                        foregroundColor: AppColors.charcoalBlack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text('Tra Cứu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      onPressed: () {
                        setModalState(() {
                          result = LunarCalculator.calculateBuildingAge(birthYear, buildYear);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kết quả
                  if (result != null) ...[
                    // Tổng kết
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: result!.canBuild
                            ? const Color(0xFF1A2A1A)
                            : const Color(0xFF2C1814),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: result!.canBuild
                              ? Colors.green.withOpacity(0.5)
                              : const Color(0xFFE57373).withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            result!.canBuild ? Icons.check_circle : Icons.warning_amber_rounded,
                            color: result!.canBuild ? Colors.green : const Color(0xFFE57373),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              result!.overallConclusion,
                              style: TextStyle(
                                color: result!.canBuild ? Colors.green[200] : const Color(0xFFEF9A9A),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Thông tin tuổi
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.woodBorder.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tuổi ${result!.canChiBirth} · Tuổi mụ: ${result!.lunarAge}',
                            style: const TextStyle(
                              color: AppColors.woodAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Năm xây: ${result!.canChiBuild}',
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Chi tiết: Tam Tai
                    _buildResultRow(
                      icon: Icons.warning_rounded,
                      title: 'Tam Tai',
                      isHung: result!.isTamTai,
                      description: result!.tamTaiDesc,
                    ),
                    const SizedBox(height: 8),

                    // Chi tiết: Kim Lâu
                    _buildResultRow(
                      icon: Icons.lock_outline,
                      title: 'Kim Lâu ${result!.isKimLau ? "(${result!.kimLauType})" : ""}',
                      isHung: result!.isKimLau,
                      description: result!.kimLauDesc,
                    ),
                    const SizedBox(height: 8),

                    // Chi tiết: Hoang Ốc
                    _buildResultRow(
                      icon: Icons.house_outlined,
                      title: 'Hoang Ốc: ${result!.hoangOcPalace}',
                      isHung: !result!.isHoangOcGood,
                      description: result!.hoangOcDesc,
                    ),

                    // Gợi ý mượn tuổi
                    if (!result!.canBuild && result!.suggestedBorrowYears.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F2A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.people_outline, color: Colors.blue, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'GỢI Ý MƯỢN TUỔI',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: result!.suggestedBorrowYears.map((yr) {
                                final canChi = LunarCalculator.getCanChiYear(yr);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    '$yr ($canChi)',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required String title,
    required bool isHung,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHung
              ? const Color(0xFFE57373).withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16,
            color: isHung ? const Color(0xFFE57373) : Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.ivoryWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isHung
                            ? const Color(0xFFE57373).withOpacity(0.15)
                            : Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isHung ? 'HUNG' : 'CÁT',
                        style: TextStyle(
                          color: isHung ? const Color(0xFFE57373) : Colors.green,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Modal Lọc Ngày Đẹp / Chọn Ngày Tốt trong tháng
  void _showGoodDaysModal() {
    String? selectedPurpose;
    List<DateTime> matchedDays = [];

    final purposes = {
      'Động thổ': ['Động thổ', 'Khởi công'],
      'Khai trương': ['Khai trương', 'Mở kho'],
      'Cưới hỏi': ['Cưới hỏi', 'Đính hôn'],
      'Xuất hành': ['Xuất hành', 'Khởi sự'],
      'Nhập trạch': ['Nhập trạch', 'Mua bán nhà đất'],
      'Cúng tế': ['Cúng tế', 'Cúng bái tổ tiên', 'Cầu phúc'],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.85,
            expand: false,
            builder: (_, scrollCtrl) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.woodAccent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Lọc Ngày Đẹp',
                            style: TextStyle(
                              color: AppColors.woodAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  Text(
                    'Tháng ${_focusedMonth.month}/${_focusedMonth.year}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 14),

                  // Chọn mục đích
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: purposes.keys.map((purpose) {
                      final isActive = selectedPurpose == purpose;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedPurpose = purpose;
                            final keywords = purposes[purpose]!;
                            final daysInMonth = DateTime(
                                _focusedMonth.year, _focusedMonth.month + 1, 0).day;

                            matchedDays = [];
                            for (int d = 1; d <= daysInMonth; d++) {
                              final dt = DateTime(_focusedMonth.year, _focusedMonth.month, d);
                              final lunar = LunarCalculator.getFullLunarDate(dt);
                              if (lunar.isHoangDao &&
                                  !lunar.hasTaboo &&
                                  lunar.goodFor.any((g) =>
                                      keywords.any((k) => g.contains(k)))) {
                                matchedDays.add(dt);
                              }
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.woodAccent.withOpacity(0.2)
                                : AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.woodAccent
                                  : AppColors.woodBorder.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            purpose,
                            style: TextStyle(
                              color: isActive ? AppColors.woodAccent : Colors.white70,
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Danh sách ngày tốt
                  if (selectedPurpose != null) ...[
                    if (matchedDays.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1714),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white38, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Không tìm thấy ngày Hoàng Đạo phù hợp trong tháng này. Thử xem tháng khác.',
                                style: TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      Text(
                        '${matchedDays.length} ngày tốt cho "$selectedPurpose":',
                        style: const TextStyle(
                          color: AppColors.ivoryWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...matchedDays.map((dt) {
                        final lunar = LunarCalculator.getFullLunarDate(dt);
                        const weekNames = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = dt;
                            });
                            Navigator.pop(ctx);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.woodBorder.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green.withOpacity(0.4)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${dt.day}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${weekNames[dt.weekday - 1]}, ${dt.day}/${dt.month}/${dt.year}',
                                        style: const TextStyle(
                                          color: AppColors.ivoryWhite,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Âm: ${lunar.lunarDay}/${lunar.lunarMonth} · ${lunar.canChiDay}',
                                        style: const TextStyle(color: AppColors.woodAccent, fontSize: 11),
                                      ),
                                      Text(
                                        '${lunar.truc.split(" ").first} · ${lunar.hoangDaoStar.split(" ").first}',
                                        style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Xây dựng danh sách 35 hoặc 42 ngày cho lưới lịch tháng
  List<DateTime> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;

    final firstWeekday = firstDayOfMonth.weekday;
    final leadingDays = firstWeekday - 1;

    final List<DateTime> days = [];

    for (int i = leadingDays; i > 0; i--) {
      days.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    for (int i = 0; i < daysInMonth; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, i + 1));
    }

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
            _buildCalendarHeader(),
            _buildWeekDaysHeader(),
            _buildQuickToolsBar(),

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
                          childAspectRatio: 0.76,
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

                    // Legend: Hoàng Đạo, Hắc Đạo, Ngày kỵ
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE53935),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Hoàng đạo',
                              style: TextStyle(color: Colors.white54, fontSize: 11)),
                          const SizedBox(width: 12),
                          Container(
                            width: 6, height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6E6864),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Hắc đạo',
                              style: TextStyle(color: Colors.white54, fontSize: 11)),
                          const SizedBox(width: 12),
                          Container(
                            width: 6, height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFFB74D),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Ngày kỵ',
                              style: TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

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

  /// Quick Tools Bar: Tuổi Làm Nhà & Lọc Ngày Đẹp
  Widget _buildQuickToolsBar() {
    return Container(
      color: AppColors.surfaceCard,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _showBuildingAgeModal,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.woodBorder.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🏡', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text(
                      'Tuổi Làm Nhà',
                      style: TextStyle(
                        color: AppColors.woodAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: _showGoodDaysModal,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.woodBorder.withOpacity(0.4)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('✨', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Text(
                      'Lọc Ngày Đẹp',
                      style: TextStyle(
                        color: AppColors.woodAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      color: AppColors.northRed,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
            tooltip: 'Tháng trước',
            onPressed: _previousMonth,
          ),
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
