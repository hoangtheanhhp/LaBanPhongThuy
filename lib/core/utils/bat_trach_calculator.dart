enum Gender { male, female }

enum BatTrachDirectionType {
  // Good (Cát)
  sinhKhi('Sinh Khí', 'Tài lộc vẹn toàn, thăng quan tiến chức', true),
  thienY('Thiên Y', 'Sức khỏe dồi dào, quý nhân phù trợ', true),
  dienNien('Diên Niên', 'Gia đạo hòa thuận, tình duyên êm ấm', true),
  phucVi('Phục Vị', 'Tâm an chí vững, học hành thi cử may mắn', true),
  // Bad (Hung)
  hoaHai('Họa Hại', 'Hung khí, bất hòa, thị phi', false),
  lucSat('Lục Sát', 'Trục trặc tình duyên, kiện tụng tai tiếng', false),
  nguQuy('Ngũ Quỷ', 'Hao tán tiền của, tiểu nhân quấy phá', false),
  tuyetMenh('Tuyệt Mệnh', 'Đại hung, ảnh hưởng sức khỏe, bổn mạng', false);

  final String name;
  final String description;
  final bool isGood;

  const BatTrachDirectionType(this.name, this.description, this.isGood);
}

enum CungPhi {
  kham(1, 'Khảm', 'Thủy', 'Đông Tứ Mệnh'),
  khon(2, 'Khôn', 'Thổ', 'Tây Tứ Mệnh'),
  chan(3, 'Chấn', 'Mộc', 'Đông Tứ Mệnh'),
  ton(4, 'Tốn', 'Mộc', 'Đông Tứ Mệnh'),
  canKim(6, 'Càn', 'Kim', 'Tây Tứ Mệnh'),
  doai(7, 'Đoài', 'Kim', 'Tây Tứ Mệnh'),
  canTho(8, 'Cấn', 'Thổ', 'Tây Tứ Mệnh'),
  ly(9, 'Ly', 'Hỏa', 'Đông Tứ Mệnh');

  final int number;
  final String vietnameseName;
  final String nguHanh;
  final String nhom;

  const CungPhi(this.number, this.vietnameseName, this.nguHanh, this.nhom);
}

class BatTrachCalculator {
  /// Calculate Quái Số from birth year and gender
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

    // Special rule for Quái 5 (Trung Cung): Nam -> Khôn (2), Nữ -> Cấn (8)
    if (quaiNumber == 5) {
      return gender == Gender.male ? CungPhi.khon : CungPhi.canTho;
    }

    return CungPhi.values.firstWhere((c) => c.number == quaiNumber);
  }

  /// 8 Directional mapping for a given Cung Phi
  /// Degrees: 0: N, 45: NE, 90: E, 135: SE, 180: S, 225: SW, 270: W, 315: NW
  static Map<int, BatTrachDirectionType> getDirectionMeanings(CungPhi cung) {
    switch (cung) {
      case CungPhi.canKim: // Càn (Tây Tứ Mệnh)
        return {
          0: BatTrachDirectionType.lucSat,    // Bắc (Khảm)
          45: BatTrachDirectionType.thienY,   // Đông Bắc (Cấn)
          90: BatTrachDirectionType.nguQuy,   // Đông (Chấn)
          135: BatTrachDirectionType.hoaHai,  // Đông Nam (Tốn)
          180: BatTrachDirectionType.tuyetMenh, // Nam (Ly)
          225: BatTrachDirectionType.dienNien,  // Tây Nam (Khôn)
          270: BatTrachDirectionType.sinhKhi,   // Tây (Đoài)
          315: BatTrachDirectionType.phucVi,    // Tây Bắc (Càn)
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
      case CungPhi.chan: // Chấn (Đông Tứ Mệnh)
        return {
          0: BatTrachDirectionType.thienY,
          45: BatTrachDirectionType.lucSat,
          90: BatTrachDirectionType.phucVi,
          135: BatTrachDirectionType.dienNien,
          180: BatTrachDirectionType.sinhKhi,
          225: BatTrachDirectionType.hoaHai,
          270: BatTrachDirectionType.tuyetMenh,
          315: BatTrachDirectionType.nguQuy,
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
