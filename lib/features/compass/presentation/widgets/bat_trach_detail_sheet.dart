import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/bat_trach_calculator.dart';

/// Bottom sheet chi tiết toàn bộ thông tin Cung Phi & Bát Trạch
class BatTrachDetailSheet extends StatelessWidget {
  final CungPhi cungPhi;
  const BatTrachDetailSheet({super.key, required this.cungPhi});

  static const Map<String, String> _cungSymbol = {
    'KHẢM': '☵', 'CẤN': '☶', 'CHẤN': '☳', 'TỐN': '☴',
    'LY': '☲', 'KHÔN': '☷', 'ĐOÀI': '☱', 'CÀN': '☰',
  };

  static const Map<String, List<String>> _cungDetails = {
    'KHẢM': [
      'Hành: Thủy (水)',
      'Số quái: 1',
      'Màu đại diện: Xanh navy, đen',
      'Mùa: Đông',
      'Thiên can: Nhâm, Quý',
      'Phẩm chất: Trí tuệ, uyển chuyển, thích nghi',
      'Sự nghiệp: Nghề nghiên cứu, tài chính, hàng hải',
      'Sức khỏe: Chú ý thận, tai, hệ tiết niệu',
    ],
    'CẤN': [
      'Hành: Thổ (土)',
      'Số quái: 8',
      'Màu đại diện: Vàng đất, nâu',
      'Mùa: Cuối Đông - Đầu Xuân',
      'Thiên can: Mậu (phần)',
      'Phẩm chất: Trung thực, bền bỉ, thực tế',
      'Sự nghiệp: Địa ốc, xây dựng, nông nghiệp',
      'Sức khỏe: Chú ý xương khớp, tay, lưng',
    ],
    'CHẤN': [
      'Hành: Mộc (木)',
      'Số quái: 3',
      'Màu đại diện: Xanh lá, lam',
      'Mùa: Xuân',
      'Thiên can: Giáp, Ất',
      'Phẩm chất: Năng động, tiên phong, nhiệt huyết',
      'Sự nghiệp: Quản lý, thể thao, khởi nghiệp',
      'Sức khỏe: Chú ý gan, mật, chân trái',
    ],
    'TỐN': [
      'Hành: Mộc (木)',
      'Số quái: 4',
      'Màu đại diện: Xanh lá nhạt',
      'Mùa: Cuối Xuân - Đầu Hè',
      'Thiên can: Giáp, Ất (phần)',
      'Phẩm chất: Linh hoạt, giao tiếp, sáng tạo',
      'Sự nghiệp: Truyền thông, nghệ thuật, du lịch',
      'Sức khỏe: Chú ý đùi, hô hấp, ruột',
    ],
    'LY': [
      'Hành: Hỏa (火)',
      'Số quái: 9',
      'Màu đại diện: Đỏ, cam, tím',
      'Mùa: Hè',
      'Thiên can: Bính, Đinh',
      'Phẩm chất: Rạng rỡ, thông tuệ, nghệ thuật',
      'Sự nghiệp: Văn học, giảng dạy, thẩm mỹ',
      'Sức khỏe: Chú ý tim, mắt, huyết áp',
    ],
    'KHÔN': [
      'Hành: Thổ (土)',
      'Số quái: 2',
      'Màu đại diện: Vàng, đen',
      'Mùa: Cuối Hè - Đầu Thu',
      'Thiên can: Kỷ (phần)',
      'Phẩm chất: Nhẫn nại, bao dung, nuôi dưỡng',
      'Sự nghiệp: Y tế, giáo dục, từ thiện',
      'Sức khỏe: Chú ý dạ dày, lá lách, cột sống',
    ],
    'ĐOÀI': [
      'Hành: Kim (金)',
      'Số quái: 7',
      'Màu đại diện: Trắng, bạc',
      'Mùa: Thu',
      'Thiên can: Canh, Tân',
      'Phẩm chất: Vui vẻ, hòa nhã, ngoại giao',
      'Sự nghiệp: Ngoại giao, diễn thuyết, kinh doanh',
      'Sức khỏe: Chú ý phổi, miệng, da',
    ],
    'CÀN': [
      'Hành: Kim (金)',
      'Số quái: 6',
      'Màu đại diện: Trắng, vàng, xám',
      'Mùa: Cuối Thu - Đầu Đông',
      'Thiên can: Canh, Tân (phần)',
      'Phẩm chất: Lãnh đạo, cao thượng, uy quyền',
      'Sự nghiệp: Chính trị, quân đội, kinh doanh lớn',
      'Sức khỏe: Chú ý đầu, phổi, ruột già',
    ],
  };

  static const Map<int, String> _directionName = {
    0: 'Bắc (Khảm)',
    45: 'Đông Bắc (Cấn)',
    90: 'Đông (Chấn)',
    135: 'Đông Nam (Tốn)',
    180: 'Nam (Ly)',
    225: 'Tây Nam (Khôn)',
    270: 'Tây (Đoài)',
    315: 'Tây Bắc (Càn)',
  };

  static const Map<String, String> _meaningDesc = {
    'SINH KHÍ': 'Sinh Khí — Cát khí thịnh vượng nhất. Tài lộc, danh vọng, sức khỏe dồi dào. Thích hợp đặt bàn làm việc, cửa chính, phòng ngủ.',
    'THIÊN Y': 'Thiên Y — Quý nhân phù trợ, sức khỏe tốt. Chữa bệnh, hồi phục, may mắn trong hôn nhân và học tập.',
    'DIÊN NIÊN': 'Diên Niên — Gia đình hòa thuận, tình duyên đẹp. Phù hợp phòng khách, bàn thờ gia tiên.',
    'PHỤC VỊ': 'Phục Vị — Bình ổn, học hành tiến bộ. Năng lượng trung tính, giữ nguyên trạng tốt.',
    'HỌA HẠI': 'Họa Hại — Tranh cãi, thị phi, bất hòa. Tránh đặt bếp núc, phòng khách ở hướng này.',
    'LỤC SÁT': 'Lục Sát — Tình duyên lận đận, kiện tụng. Tránh cửa chính hướng này.',
    'NGŨ QUỶ': 'Ngũ Quỷ — Hao tán tiền tài, tiểu nhân. Tránh đặt két tiền, cửa quan trọng.',
    'TUYỆT MỆNH': 'Tuyệt Mệnh — Đại hung, sức khỏe, tài chính đều bị ảnh hưởng. Nên tránh hoàn toàn.',
  };

  @override
  Widget build(BuildContext context) {
    final meanings = BatTrachCalculator.getDirectionMeanings(cungPhi);
    final symbol = _cungSymbol[cungPhi.vietnameseName] ?? '○';
    final details = _cungDetails[cungPhi.vietnameseName] ?? [];
    final goodDirs = meanings.entries.where((e) => e.value.isGood).toList()
      ..sort((a, b) {
        const rank = {
          BatTrachDirectionType.sinhKhi: 0,
          BatTrachDirectionType.thienY: 1,
          BatTrachDirectionType.dienNien: 2,
          BatTrachDirectionType.phucVi: 3,
        };
        return (rank[a.value] ?? 9).compareTo(rank[b.value] ?? 9);
      });
    final badDirs = meanings.entries.where((e) => !e.value.isGood).toList()
      ..sort((a, b) {
        const rank = {
          BatTrachDirectionType.tuyetMenh: 0,
          BatTrachDirectionType.nguQuy: 1,
          BatTrachDirectionType.lucSat: 2,
          BatTrachDirectionType.hoaHai: 3,
        };
        return (rank[a.value] ?? 9).compareTo(rank[b.value] ?? 9);
      });

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CustomScrollView(
          controller: scrollCtrl,
          slivers: [
            // Drag handle
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Text(symbol,
                        style: const TextStyle(fontSize: 40, color: AppColors.woodAccent)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cung ${cungPhi.vietnameseName}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.woodAccent,
                            ),
                          ),
                          Text(
                            '${cungPhi.nguHanh} · ${cungPhi.nhom} · Quái số ${cungPhi.number}',
                            style: const TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.white38),
                    ),
                  ],
                ),
              ),
            ),

            // Cung details
            SliverToBoxAdapter(
              child: _Section(
                title: 'Thông tin Cung Mạng',
                child: Column(
                  children: details.map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: AppColors.woodAccent)),
                        Expanded(
                          child: Text(d,
                              style: const TextStyle(color: Colors.white70, fontSize: 13.5)),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ),

            // Auspicious directions
            SliverToBoxAdapter(
              child: _Section(
                title: '✦ 4 Hướng Cát (Tốt)',
                titleColor: AppColors.woodAccent,
                child: Column(
                  children: goodDirs.map((e) {
                    final dirName = _directionName[e.key] ?? '${e.key}°';
                    final desc = _meaningDesc[e.value.name] ?? e.value.description;
                    return _DirectionDetailCard(
                      dirName: dirName,
                      meaning: e.value,
                      description: desc,
                      isGood: true,
                    );
                  }).toList(),
                ),
              ),
            ),

            // Inauspicious directions
            SliverToBoxAdapter(
              child: _Section(
                title: '✦ 4 Hướng Hung (Xấu)',
                titleColor: const Color(0xFFE57373),
                child: Column(
                  children: badDirs.map((e) {
                    final dirName = _directionName[e.key] ?? '${e.key}°';
                    final desc = _meaningDesc[e.value.name] ?? e.value.description;
                    return _DirectionDetailCard(
                      dirName: dirName,
                      meaning: e.value,
                      description: desc,
                      isGood: false,
                    );
                  }).toList(),
                ),
              ),
            ),

            // Usage tips
            SliverToBoxAdapter(
              child: _Section(
                title: '💡 Ứng dụng thực tế',
                child: const Column(
                  children: [
                    _TipRow(icon: Icons.bed_outlined, text: 'Kê giường ngủ hướng Sinh Khí hoặc Thiên Y để tăng sức khoẻ'),
                    SizedBox(height: 8),
                    _TipRow(icon: Icons.work_outline, text: 'Bàn làm việc quay về Sinh Khí để tăng tài lộc, may mắn'),
                    SizedBox(height: 8),
                    _TipRow(icon: Icons.home_outlined, text: 'Cửa chính nên mở theo hướng Diên Niên hoặc Thiên Y'),
                    SizedBox(height: 8),
                    _TipRow(icon: Icons.local_fire_department_outlined, text: 'Tránh đặt bếp lửa ở hướng Tuyệt Mệnh hoặc Ngũ Quỷ'),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Color titleColor;

  const _Section({
    required this.title,
    required this.child,
    this.titleColor = Colors.white60,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: titleColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
          child,
          const Divider(color: AppColors.woodBorder, height: 24, thickness: 0.4),
        ],
      ),
    );
  }
}

class _DirectionDetailCard extends StatelessWidget {
  final String dirName;
  final BatTrachDirectionType meaning;
  final String description;
  final bool isGood;

  const _DirectionDetailCard({
    required this.dirName,
    required this.meaning,
    required this.description,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isGood ? const Color(0xFF1A1C12) : const Color(0xFF160E0E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isGood
              ? AppColors.woodAccent.withOpacity(0.2)
              : const Color(0xFF8B2020).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isGood
                      ? AppColors.woodAccent.withOpacity(0.15)
                      : const Color(0xFF8B2020).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  meaning.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isGood ? AppColors.woodAccent : const Color(0xFFE57373),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dirName,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.woodAccent, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4)),
        ),
      ],
    );
  }
}
