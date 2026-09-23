enum Gender { male, female }

enum BatTrachDirectionType {
  // Good (Cát)
  sinhKhi('SINH KHÍ', 'Tài lộc vẹn toàn, thăng quan tiến chức', true),
  thienY('THIÊN Y', 'Sức khỏe dồi dào, quý nhân phù trợ', true),
  dienNien('DIÊN NIÊN', 'Gia đạo hòa thuận, tình duyên êm ấm', true),
  phucVi('PHỤC VỊ', 'Tâm an chí vững, học hành thi cử may mắn', true),
  // Bad (Hung)
  hoaHai('HỌA HẠI', 'Hung khí, bất hòa, thị phi', false),
  lucSat('LỤC SÁT', 'Trục trặc tình duyên, kiện tụng tai tiếng', false),
  nguQuy('NGŨ QUỶ', 'Hao tán tiền của, tiểu nhân quấy phá', false),
  tuyetMenh('TUYỆT MỆNH', 'Đại hung, ảnh hưởng sức khỏe, bổn mạng', false);

  final String name;
  final String description;
  final bool isGood;

  const BatTrachDirectionType(this.name, this.description, this.isGood);
}

enum CungPhi {
  kham(1, 'KHẢM', 'Thủy', 'Đông Tứ Mệnh'),
  khon(2, 'KHÔN', 'Thổ', 'Tây Tứ Mệnh'),
  chan(3, 'CHẤN', 'Mộc', 'Đông Tứ Mệnh'),
  ton(4, 'TỐN', 'Mộc', 'Đông Tứ Mệnh'),
  canKim(6, 'CÀN', 'Kim', 'Tây Tứ Mệnh'),
  doai(7, 'ĐOÀI', 'Kim', 'Tây Tứ Mệnh'),
  canTho(8, 'CẤN', 'Thổ', 'Tây Tứ Mệnh'),
  ly(9, 'LY', 'Hỏa', 'Đông Tứ Mệnh');

  final int number;
  final String vietnameseName;
  final String nguHanh;
  final String nhom;

  const CungPhi(this.number, this.vietnameseName, this.nguHanh, this.nhom);
}

class BatTrachCalculator {
  /// 24 Sơn Hướng theo chiều kim đồng hồ bắt đầu từ 0° (Bắc - Tý)
  /// Mỗi sơn góc rộng 15° (từ -7.5° đến +7.5° so với tâm sơn)
  static const List<Map<String, dynamic>> son24List = [
    {'name': 'TÝ', 'angle': 0.0, 'cung': 'BẮC', 'nhom': 'Đông Tứ'},
    {'name': 'QUÝ', 'angle': 15.0, 'cung': 'BẮC', 'nhom': 'Đông Tứ'},
    {'name': 'SỬU', 'angle': 30.0, 'cung': 'ĐÔNG BẮC', 'nhom': 'Tây Tứ'},
    {'name': 'CẤN', 'angle': 45.0, 'cung': 'ĐÔNG BẮC', 'nhom': 'Tây Tứ'},
    {'name': 'DẦN', 'angle': 60.0, 'cung': 'ĐÔNG BẮC', 'nhom': 'Tây Tứ'},
    {'name': 'GIÁP', 'angle': 75.0, 'cung': 'ĐÔNG', 'nhom': 'Đông Tứ'},
    {'name': 'MÃO', 'angle': 90.0, 'cung': 'ĐÔNG', 'nhom': 'Đông Tứ'},
    {'name': 'ẤT', 'angle': 105.0, 'cung': 'ĐÔNG', 'nhom': 'Đông Tứ'},
    {'name': 'THÌN', 'angle': 120.0, 'cung': 'ĐÔNG NAM', 'nhom': 'Đông Tứ'},
    {'name': 'TỐN', 'angle': 135.0, 'cung': 'ĐÔNG NAM', 'nhom': 'Đông Tứ'},
    {'name': 'TỴ', 'angle': 150.0, 'cung': 'ĐÔNG NAM', 'nhom': 'Đông Tứ'},
    {'name': 'BÍNH', 'angle': 165.0, 'cung': 'NAM', 'nhom': 'Đông Tứ'},
    {'name': 'NGỌ', 'angle': 180.0, 'cung': 'NAM', 'nhom': 'Đông Tứ'},
    {'name': 'ĐINH', 'angle': 195.0, 'cung': 'NAM', 'nhom': 'Đông Tứ'},
    {'name': 'MÙI', 'angle': 210.0, 'cung': 'TÂY NAM', 'nhom': 'Tây Tứ'},
    {'name': 'KHÔN', 'angle': 225.0, 'cung': 'TÂY NAM', 'nhom': 'Tây Tứ'},
    {'name': 'THÂN', 'angle': 240.0, 'cung': 'TÂY NAM', 'nhom': 'Tây Tứ'},
    {'name': 'CANH', 'angle': 255.0, 'cung': 'TÂY', 'nhom': 'Tây Tứ'},
    {'name': 'DẬU', 'angle': 270.0, 'cung': 'TÂY', 'nhom': 'Tây Tứ'},
    {'name': 'TÂN', 'angle': 285.0, 'cung': 'TÂY', 'nhom': 'Tây Tứ'},
    {'name': 'TUẤT', 'angle': 300.0, 'cung': 'TÂY BẮC', 'nhom': 'Tây Tứ'},
    {'name': 'CÀN', 'angle': 315.0, 'cung': 'TÂY BẮC', 'nhom': 'Tây Tứ'},
    {'name': 'HỢI', 'angle': 330.0, 'cung': 'TÂY BẮC', 'nhom': 'Tây Tứ'},
    {'name': 'NHÂM', 'angle': 345.0, 'cung': 'BẮC', 'nhom': 'Đông Tứ'},
  ];

  /// 24 Phúc Đức (Phước Đức) theo vòng La bàn Bát Trạch
  static const List<Map<String, dynamic>> phucDuc24List = [
    {'name': 'THÂN HÔN', 'angle': 0.0, 'isGood': true},
    {'name': 'HOAN LẠC', 'angle': 15.0, 'isGood': true},
    {'name': 'BẠI TUYỆT', 'angle': 30.0, 'isGood': false},
    {'name': 'VƯỢNG TÀI', 'angle': 45.0, 'isGood': true},
    {'name': 'PHƯỚC ĐỨC', 'angle': 60.0, 'isGood': true},
    {'name': 'ÔN HOÀNG', 'angle': 75.0, 'isGood': false},
    {'name': 'TẤN TÀI', 'angle': 90.0, 'isGood': true},
    {'name': 'TRƯỜNG BỆNH', 'angle': 105.0, 'isGood': false},
    {'name': 'TỐ TỤNG', 'angle': 120.0, 'isGood': false},
    {'name': 'QUAN TƯỚC', 'angle': 135.0, 'isGood': true},
    {'name': 'QUAN QUÝ', 'angle': 150.0, 'isGood': true},
    {'name': 'TỰ ẢI', 'angle': 165.0, 'isGood': false},
    {'name': 'VƯỢNG TRANG', 'angle': 180.0, 'isGood': true},
    {'name': 'HƯNG PHƯỚC', 'angle': 195.0, 'isGood': true},
    {'name': 'PHÁP TRƯỜNG', 'angle': 210.0, 'isGood': false},
    {'name': 'ĐIÊN CUỒNG', 'angle': 225.0, 'isGood': false},
    {'name': 'KHẨU THIỆT', 'angle': 240.0, 'isGood': false},
    {'name': 'VƯỢNG TÂM', 'angle': 255.0, 'isGood': true},
    {'name': 'TẤN ĐIỀN', 'angle': 270.0, 'isGood': true},
    {'name': 'KHÓC KHÓC', 'angle': 285.0, 'isGood': false},
    {'name': 'CÔ QUẢ', 'angle': 300.0, 'isGood': false},
    {'name': 'LAO PHÙ', 'angle': 315.0, 'isGood': false},
    {'name': 'THIẾU VONG', 'angle': 330.0, 'isGood': false},
    {'name': 'XƯƠNG DÂM', 'angle': 345.0, 'isGood': false},
  ];

  /// Tính Quái Số Cung Phi từ năm sinh và giới tính
  static CungPhi calculateCungPhi(int birthYear, Gender gender) {
    int sum = birthYear % 100;
    while (sum >= 10) {
      sum = (sum ~/ 10) + (sum % 10);
    }

    int quaiNumber;
    if (birthYear < 2000) {
      if (gender == Gender.male) {
        quaiNumber = (10 - sum) % 9;
        if (quaiNumber == 0) quaiNumber = 9;
      } else {
        quaiNumber = (5 + sum) % 9;
        if (quaiNumber == 0) quaiNumber = 9;
      }
    } else {
      if (gender == Gender.male) {
        quaiNumber = (9 - sum) % 9;
        if (quaiNumber == 0) quaiNumber = 9;
      } else {
        quaiNumber = (6 + sum) % 9;
        if (quaiNumber == 0) quaiNumber = 9;
      }
    }

    // Đặc biệt Quái 5 (Trung Cung): Nam -> Khôn (2), Nữ -> Cấn (8)
    if (quaiNumber == 5) {
      return gender == Gender.male ? CungPhi.khon : CungPhi.canTho;
    }

    return CungPhi.values.firstWhere((c) => c.number == quaiNumber);
  }

  /// 8 Hướng Bát Trạch tương ứng góc: 0: Bắc, 45: ĐB, 90: Đ, 135: ĐN, 180: N, 225: TN, 270: T, 315: TB
  static Map<int, BatTrachDirectionType> getDirectionMeanings(CungPhi cung) {
    switch (cung) {
      case CungPhi.canKim: // Càn (Tây Tứ Mệnh)
        return {
          0: BatTrachDirectionType.lucSat,
          45: BatTrachDirectionType.thienY,
          90: BatTrachDirectionType.nguQuy,
          135: BatTrachDirectionType.hoaHai,
          180: BatTrachDirectionType.tuyetMenh,
          225: BatTrachDirectionType.dienNien,
          270: BatTrachDirectionType.sinhKhi,
          315: BatTrachDirectionType.phucVi,
        };
      case CungPhi.kham: // Khảm (Đông Tứ Mệnh)
        return {
          0: BatTrachDirectionType.phucVi,
          45: BatTrachDirectionType.nguQuy,
          90: BatTrachDirectionType.thienY,
          135: BatTrachDirectionType.sinhKhi,
          180: BatTrachDirectionType.dienNien,
          225: BatTrachDirectionType.tuyetMenh,
          270: BatTrachDirectionType.hoaHai,
          315: BatTrachDirectionType.lucSat,
        };
      case CungPhi.ly: // Ly (Đông Tứ Mệnh)
        return {
          0: BatTrachDirectionType.dienNien,
          45: BatTrachDirectionType.hoaHai,
          90: BatTrachDirectionType.sinhKhi,
          135: BatTrachDirectionType.thienY,
          180: BatTrachDirectionType.phucVi,
          225: BatTrachDirectionType.lucSat,
          270: BatTrachDirectionType.nguQuy,
          315: BatTrachDirectionType.tuyetMenh,
        };
      case CungPhi.chan: // Chấn (Đông Tứ Mệnh - Tuổi 1997 Đinh Sửu Nam)
        return {
          0: BatTrachDirectionType.thienY,    // Bắc: Thiên Y (Cát)
          45: BatTrachDirectionType.lucSat,   // Đông Bắc: Lục Sát (Hung)
          90: BatTrachDirectionType.phucVi,   // Đông: Phục Vị (Cát)
          135: BatTrachDirectionType.dienNien,// Đông Nam: Diên Niên / Phước Đức (Cát)
          180: BatTrachDirectionType.sinhKhi, // Nam: Sinh Khí (Cát)
          225: BatTrachDirectionType.hoaHai,  // Tây Nam: Họa Hại (Hung)
          270: BatTrachDirectionType.tuyetMenh,// Tây: Tuyệt Mạng / Tuyệt Mệnh (Hung)
          315: BatTrachDirectionType.nguQuy,  // Tây Bắc: Ngũ Quỷ (Hung)
        };
      case CungPhi.ton: // Tốn (Đông Tứ Mệnh)
        return {
          0: BatTrachDirectionType.sinhKhi,
          45: BatTrachDirectionType.tuyetMenh,
          90: BatTrachDirectionType.dienNien,
          135: BatTrachDirectionType.phucVi,
          180: BatTrachDirectionType.thienY,
          225: BatTrachDirectionType.nguQuy,
          270: BatTrachDirectionType.lucSat,
          315: BatTrachDirectionType.hoaHai,
        };
      case CungPhi.canTho: // Cấn (Tây Tứ Mệnh)
        return {
          0: BatTrachDirectionType.nguQuy,
          45: BatTrachDirectionType.phucVi,
          90: BatTrachDirectionType.lucSat,
          135: BatTrachDirectionType.tuyetMenh,
          180: BatTrachDirectionType.hoaHai,
          225: BatTrachDirectionType.sinhKhi,
          270: BatTrachDirectionType.dienNien,
          315: BatTrachDirectionType.thienY,
        };
      case CungPhi.khon: // Khôn (Tây Tứ Mệnh)
        return {
          0: BatTrachDirectionType.tuyetMenh,
          45: BatTrachDirectionType.sinhKhi,
          90: BatTrachDirectionType.hoaHai,
          135: BatTrachDirectionType.nguQuy,
          180: BatTrachDirectionType.lucSat,
          225: BatTrachDirectionType.phucVi,
          270: BatTrachDirectionType.thienY,
          315: BatTrachDirectionType.dienNien,
        };
      case CungPhi.doai: // Đoài (Tây Tứ Mệnh)
        return {
          0: BatTrachDirectionType.hoaHai,
          45: BatTrachDirectionType.dienNien,
          90: BatTrachDirectionType.tuyetMenh,
          135: BatTrachDirectionType.lucSat,
          180: BatTrachDirectionType.nguQuy,
          225: BatTrachDirectionType.thienY,
          270: BatTrachDirectionType.phucVi,
          315: BatTrachDirectionType.sinhKhi,
        };
    }
  }
}
