import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bat_trach_calculator.dart';
import '../../../core/utils/compass_math.dart';
import 'widgets/bagua_dial.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double _smoothHeading = 0.0;
  
  // Example user profile state (Can be swapped with Riverpod provider)
  CungPhi? _activeCungPhi = CungPhi.canKim; // Càn (Tây Tứ Mệnh)

  void _showProfileModal() {
    int selectedYear = 1990;
    Gender selectedGender = Gender.male;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final calculatedCung = BatTrachCalculator.calculateCungPhi(selectedYear, selectedGender);
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thiết lập Mệnh Quái (Bát Trạch)',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Năm sinh: ', style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(width: 12),
                      DropdownButton<int>(
                        value: selectedYear,
                        dropdownColor: AppColors.surfaceElevated,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        items: List.generate(80, (index) => 1950 + index)
                            .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedYear = val);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Giới tính: ', style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('Nam'),
                        selected: selectedGender == Gender.male,
                        onSelected: (val) => setModalState(() => selectedGender = Gender.male),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Nữ'),
                        selected: selectedGender == Gender.female,
                        onSelected: (val) => setModalState(() => selectedGender = Gender.female),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Cung Mạng: ${calculatedCung.vietnameseName} (${calculatedCung.nguHanh}) - ${calculatedCung.nhom}',
                      style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _activeCungPhi = calculatedCung;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Áp dụng vào La Bàn', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('La Bàn Phong Thuỷ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.primaryGold),
            tooltip: 'Cài đặt Mệnh Quái',
            onPressed: _showProfileModal,
          ),
        ],
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi cảm biến: ${snapshot.error}',
                style: const TextStyle(color: AppColors.badDirection),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
          }

          final rawHeading = snapshot.data?.heading;
          if (rawHeading == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Thiết bị không có cảm biến từ trường (Magnetometer).\nVui lòng chạy trên thiết bị di động thực.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            );
          }

          // Damping & shortest-angle wrapping
          final delta = CompassMath.shortestAngleDelta(_smoothHeading, rawHeading);
          _smoothHeading = (_smoothHeading + delta * 0.22) % 360;

          final currentHeading = (_smoothHeading + 360) % 360;
          final currentDirection = CompassMath.degreeToDirection(currentHeading);
          final closestSector = CompassMath.closestSectorAngle(currentHeading);

          BatTrachDirectionType? activeDirectionMeaning;
          if (_activeCungPhi != null) {
            activeDirectionMeaning = BatTrachCalculator.getDirectionMeanings(_activeCungPhi!)[closestSector];
          }

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header degree readout
                Text(
                  '${currentHeading.toStringAsFixed(0)}°',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGold,
                  ),
                ),
                Text(
                  currentDirection,
                  style: const TextStyle(fontSize: 16, color: Colors.white70, letterSpacing: 0.5),
                ),
                const SizedBox(height: 16),

                // Compass Viewport
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Bagua Plate (Rotates counter to heading)
                      Transform.rotate(
                        angle: -CompassMath.toRadians(_smoothHeading),
                        child: BaguaDial(
                          size: 375, // Tăng kích thước la bàn lớn hơn, rõ nét hơn
                          activeCungPhi: _activeCungPhi,
                        ),
                      ),
                      // Precision Red Needle (Kim Chỉ Nam dài xuyên tâm TRƯỚC - SAU)
                      IgnorePointer(
                        child: Container(
                          width: 3.5,
                          height: 375,
                          color: const Color(0xFFD32F2F).withOpacity(0.9),
                        ),
                      ),
                      // Mũi tên định hướng phương TRƯỚC (Chính đỉnh)
                      const Positioned(
                        top: 0,
                        child: Icon(Icons.arrow_drop_down, color: Color(0xFFD32F2F), size: 36),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Active Direction Auspicious Status Pill
                if (activeDirectionMeaning != null)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: activeDirectionMeaning.isGood
                          ? AppColors.goodDirection.withOpacity(0.15)
                          : AppColors.badDirection.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: activeDirectionMeaning.isGood
                            ? AppColors.goodDirection
                            : AppColors.badDirection,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          activeDirectionMeaning.isGood ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                          color: activeDirectionMeaning.isGood
                              ? AppColors.goodDirection
                              : AppColors.badDirection,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${activeDirectionMeaning.name} (${activeDirectionMeaning.isGood ? "Cát" : "Hung"}): ${activeDirectionMeaning.description}',
                          style: TextStyle(
                            color: activeDirectionMeaning.isGood
                                ? AppColors.goodDirection
                                : AppColors.badDirection,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Text(
                    'Chạm góc trên để chọn năm sinh & giới tính',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
