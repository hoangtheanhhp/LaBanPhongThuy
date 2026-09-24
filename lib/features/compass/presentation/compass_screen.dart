import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bat_trach_calculator.dart';
import '../../../core/utils/compass_math.dart';
import 'widgets/bagua_dial.dart';
import 'widgets/cung_info_panel.dart';
import 'widgets/bat_trach_detail_sheet.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  // ── Sensor ──────────────────────────────────────────────
  StreamSubscription<CompassEvent>? _compassSub;
  double _smoothHeading = 0.0;
  double? _accuracy; // sensor accuracy in degrees
  bool _initialized = false;
  bool _sensorAvailable = true;

  // ── User Profile ─────────────────────────────────────────
  CungPhi? _activeCungPhi;
  int _selectedYear = 1990;
  Gender _selectedGender = Gender.male;

  // ── Lifecycle ────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _startCompassStream();
  }

  void _startCompassStream() {
    _compassSub = FlutterCompass.events?.listen(
      (event) {
        final raw = event.heading;
        if (raw == null) {
          if (mounted) setState(() => _sensorAvailable = false);
          return;
        }
        if (mounted) {
          setState(() {
            _sensorAvailable = true;
            _accuracy = event.headingAccuracy;
            if (!_initialized) {
              // Snap immediately to first reading — avoids "reversed" initial display
              _smoothHeading = raw;
              _initialized = true;
            } else {
              final delta = CompassMath.shortestAngleDelta(_smoothHeading, raw);
              _smoothHeading = (_smoothHeading + delta * 0.18) % 360;
            }
          });
        }
      },
      onError: (_) {
        if (mounted) setState(() => _sensorAvailable = false);
      },
    );
  }

  @override
  void dispose() {
    _compassSub?.cancel();
    super.dispose();
  }

  // ── Computed Values ───────────────────────────────────────
  double get _heading => (_smoothHeading + 360) % 360;
  int get _closestSector => CompassMath.closestSectorAngle(_heading);
  BatTrachDirectionType? get _activeMeaning =>
      _activeCungPhi != null
          ? BatTrachCalculator.getDirectionMeanings(_activeCungPhi!)[_closestSector]
          : null;

  // ── UI Builders ───────────────────────────────────────────

  void _showProfileModal() {
    int year = _selectedYear;
    Gender gender = _selectedGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          final cung = BatTrachCalculator.calculateCungPhi(year, gender);
          return Padding(
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 4, height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.woodAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Thiết lập Mệnh Quái (Bát Trạch)',
                      style: TextStyle(
                        color: AppColors.woodAccent,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Year picker
                Row(
                  children: [
                    const Text('Năm sinh: ',
                        style: TextStyle(color: AppColors.ivoryWhite, fontSize: 15)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.woodBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: year,
                            dropdownColor: AppColors.surfaceCard,
                            style: const TextStyle(color: AppColors.ivoryWhite, fontSize: 15),
                            isExpanded: true,
                            items: List.generate(80, (i) => 1945 + i)
                                .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setModal(() => year = v);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Gender picker
                Row(
                  children: [
                    const Text('Giới tính: ',
                        style: TextStyle(color: AppColors.ivoryWhite, fontSize: 15)),
                    const SizedBox(width: 12),
                    _GenderChip(
                      label: 'Nam ♂',
                      selected: gender == Gender.male,
                      onTap: () => setModal(() => gender = Gender.male),
                    ),
                    const SizedBox(width: 8),
                    _GenderChip(
                      label: 'Nữ ♀',
                      selected: gender == Gender.female,
                      onTap: () => setModal(() => gender = Gender.female),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Calculated cung preview
                _CungPreviewCard(cung: cung),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.woodAccent,
                      foregroundColor: AppColors.charcoalBlack,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 20),
                    label: const Text('Áp dụng vào La Bàn',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    onPressed: () {
                      setState(() {
                        _activeCungPhi = cung;
                        _selectedYear = year;
                        _selectedGender = gender;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBatTrachDetail() {
    if (_activeCungPhi == null) {
      _showProfileModal();
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BatTrachDetailSheet(cungPhi: _activeCungPhi!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final dialSize = (MediaQuery.of(context).size.width * 0.9).clamp(300.0, 390.0);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          'La Bàn Phong Thuỷ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.ivoryWhite,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Accuracy indicator
          if (_initialized && _accuracy != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _AccuracyDot(accuracy: _accuracy!),
            ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.woodAccent),
            tooltip: 'Thiết lập Mệnh Quái',
            onPressed: _showProfileModal,
          ),
        ],
      ),
      body: !_initialized && _sensorAvailable
          ? _buildLoading()
          : !_sensorAvailable
              ? _buildNoSensor()
              : _buildCompassBody(dialSize, screenH),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.woodAccent),
          SizedBox(height: 16),
          Text('Đang đọc cảm biến từ trường...',
              style: TextStyle(color: Colors.white54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNoSensor() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.explore_off, color: AppColors.woodAccent.withOpacity(0.6), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Thiết bị không có cảm biến từ trường (Magnetometer).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vui lòng chạy trên thiết bị Android thực có từ kế.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassBody(double dialSize, double screenH) {
    final meaning = _activeMeaning;
    final direction = CompassMath.degreeToDirection(_heading);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Heading Display ──────────────────────
            _HeadingDisplay(heading: _heading, direction: direction),
            const SizedBox(height: 12),

            // ── Compass Dial ─────────────────────────
            Center(
              child: SizedBox(
                width: dialSize,
                height: dialSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating dial
                    Transform.rotate(
                      angle: -CompassMath.toRadians(_smoothHeading),
                      child: BaguaDial(
                        size: dialSize,
                        activeCungPhi: _activeCungPhi,
                      ),
                    ),
                    // Fixed vertical axis (North-South reference line)
                    IgnorePointer(
                      child: Container(
                        width: 2,
                        height: dialSize,
                        color: AppColors.northRed.withOpacity(0.7),
                      ),
                    ),
                    // Top pointer arrow (device front = top of screen)
                    Positioned(
                      top: 0,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.northRed,
                        size: 38,
                      ),
                    ),
                    // Bottom pointer (rear direction)
                    Positioned(
                      bottom: 0,
                      child: Icon(
                        Icons.arrow_drop_up,
                        color: AppColors.northRed.withOpacity(0.4),
                        size: 28,
                      ),
                    ),
                    // Degree label on dial's 12 o'clock (live heading)
                    Positioned(
                      top: dialSize * 0.06,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.northRed.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_heading.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Active Direction Status ───────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: meaning != null
                  ? _DirectionMeaningCard(
                      meaning: meaning,
                      direction: direction,
                      onDetailTap: _showBatTrachDetail,
                    )
                  : _EmptyProfilePrompt(onTap: _showProfileModal),
            ),
            const SizedBox(height: 12),

            // ── Cung Info Panel ──────────────────────
            if (_activeCungPhi != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CungInfoPanel(
                  cungPhi: _activeCungPhi!,
                  currentHeading: _heading,
                  onDetailTap: _showBatTrachDetail,
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── Calibration Tips ──────────────────────
            if (_accuracy != null && _accuracy! > 30)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CalibrationBanner(accuracy: _accuracy!),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// Supporting Widgets
// ══════════════════════════════════════════════════════════

class _HeadingDisplay extends StatelessWidget {
  final double heading;
  final String direction;
  const _HeadingDisplay({required this.heading, required this.direction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${heading.toStringAsFixed(1)}°',
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: AppColors.woodAccent,
            letterSpacing: 1,
          ),
        ),
        Text(
          direction,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFFD7CCC8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _DirectionMeaningCard extends StatelessWidget {
  final BatTrachDirectionType meaning;
  final String direction;
  final VoidCallback onDetailTap;

  const _DirectionMeaningCard({
    required this.meaning,
    required this.direction,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGood = meaning.isGood;
    return GestureDetector(
      onTap: onDetailTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isGood ? const Color(0xFF1E1C18) : const Color(0xFF1A1614),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isGood ? AppColors.woodAccent.withOpacity(0.7) : const Color(0xFF4A3D36),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGood
                    ? AppColors.woodAccent.withOpacity(0.15)
                    : const Color(0xFF3E3835).withOpacity(0.3),
              ),
              child: Icon(
                isGood ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                color: isGood ? AppColors.woodAccent : Colors.white38,
                size: 22,
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
                        meaning.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isGood ? AppColors.woodAccent : const Color(0xFFB0BEC5),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isGood
                              ? AppColors.woodAccent.withOpacity(0.2)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isGood ? 'CÁT' : 'HUNG',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isGood ? AppColors.woodAccent : Colors.white54,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meaning.description,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}

class _EmptyProfilePrompt extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyProfilePrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.woodBorder.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_add_outlined, color: AppColors.woodAccent, size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Nhập năm sinh & giới tính để xem phương vị Cát - Hung theo Bát Trạch',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GenderChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.woodAccent.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.woodAccent : AppColors.woodBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.woodAccent : Colors.white54,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _CungPreviewCard extends StatelessWidget {
  final CungPhi cung;
  const _CungPreviewCard({required this.cung});

  static const Map<String, String> _cungDesc = {
    'KHẢM': 'Thủy — Lãnh đạo, kiên định, huyền bí. Thích nghi với thay đổi.',
    'CẤN': 'Thổ — Trung thực, thực tế, ổn định. Trọng trách và gia đình.',
    'CHẤN': 'Mộc — Năng động, quyết đoán, khởi xướng. Hành động nhanh.',
    'TỐN': 'Mộc — Linh hoạt, giao tiếp, sáng tạo. Tài hoa văn chương.',
    'LY': 'Hỏa — Rạng rỡ, thông minh, nghệ thuật. Danh tiếng nổi bật.',
    'KHÔN': 'Thổ — Nhẫn nại, bền bỉ, khiêm tốn. Nuôi dưỡng và bảo vệ.',
    'ĐOÀI': 'Kim — Hòa giải, vui vẻ, giao tiếp. Ngoại giao khéo léo.',
    'CÀN': 'Kim — Lãnh đạo, cao thượng, quyết đoán. Quyền lực và uy tín.',
  };

  @override
  Widget build(BuildContext context) {
    final desc = _cungDesc[cung.vietnameseName] ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.woodBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.woodAccent, size: 16),
              const SizedBox(width: 6),
              Text(
                'Cung Mạng: ${cung.vietnameseName}',
                style: const TextStyle(
                  color: AppColors.woodAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.woodBorder.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  cung.nhom,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(color: Colors.white60, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

class _AccuracyDot extends StatelessWidget {
  final double accuracy;
  const _AccuracyDot({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    Color color;
    String tooltip;
    if (accuracy <= 15) {
      color = const Color(0xFF4CAF50);
      tooltip = 'Cảm biến tốt';
    } else if (accuracy <= 30) {
      color = const Color(0xFFFFC107);
      tooltip = 'Cảm biến trung bình';
    } else {
      color = const Color(0xFFFF5722);
      tooltip = 'Cần hiệu chỉnh la bàn';
    }
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _CalibrationBanner extends StatelessWidget {
  final double accuracy;
  const _CalibrationBanner({required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1F0E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFC107).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFFFFC107), size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Vẽ số 8 trong không khí để hiệu chỉnh cảm biến la bàn.',
              style: TextStyle(color: Color(0xFFFFC107), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
