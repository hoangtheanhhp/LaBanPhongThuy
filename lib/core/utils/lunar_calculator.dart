import 'dart:math' as math;

/// Thông tin ngày Âm lịch & Phong thuỷ chi tiết
class LunarDate {
  final int solarDay;
  final int solarMonth;
  final int solarYear;

  final int lunarDay;
  final int lunarMonth;
  final int lunarYear;
  final bool isLeapMonth;

  final String canChiDay;
  final String canChiMonth;
  final String canChiYear;

  final bool isHoangDao;
  final String hoangDaoStar; // Thanh Long, Minh Đường, v.v.
  final String truc; // 12 Trực: Kiến, Trừ, Mãn...
  final String tietKhi; // 24 Tiết khí: Đông Chí, Lập Xuân...
  final List<String> hoangDaoHours; // Danh sách giờ hoàng đạo
  final String hyThanDirection; // Hướng Hỷ Thần
  final String taiThanDirection; // Hướng Tài Thần
  final List<String> goodFor; // Việc nên làm
  final List<String> badFor; // Việc nên kiêng
  final String xungTuoi; // Tuổi xung khắc trong ngày

  const LunarDate({
    required this.solarDay,
    required this.solarMonth,
    required this.solarYear,
    required this.lunarDay,
    required this.lunarMonth,
    required this.lunarYear,
    required this.isLeapMonth,
    required this.canChiDay,
    required this.canChiMonth,
    required this.canChiYear,
    required this.isHoangDao,
    required this.hoangDaoStar,
    required this.truc,
    required this.tietKhi,
    required this.hoangDaoHours,
    required this.hyThanDirection,
    required this.taiThanDirection,
    required this.goodFor,
    required this.badFor,
    required this.xungTuoi,
  });

  /// Chuỗi hiển thị ngày âm: ví dụ "20/11" hoặc "1/12 (Nhuận)"
  String get shortLunarText {
    if (lunarDay == 1 || lunarDay == 15) {
      return '$lunarDay/$lunarMonth${isLeapMonth ? "N" : ""}';
    }
    return '$lunarDay';
  }

  /// Chuỗi đầy đủ ngày âm: ví dụ "Ngày 20 tháng 11 năm Quý Mão"
  String get fullLunarText {
    return 'Ngày $lunarDay tháng $lunarMonth${isLeapMonth ? " (nhuận)" : ""} năm $canChiYear';
  }
}

/// Bộ tính Âm Lịch Việt Nam chuẩn thuật toán thiên văn học (Hồ Ngọc Đức & Jean Meeus)
class LunarCalculator {
  static const int timeZone = 7; // Múi giờ Việt Nam GMT+7
  static const double newMoonCycle = 29.530588853;
  static const int juliusDaysIn1900 = 2415021;

  static const List<String> canList = [
    'Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'
  ];

  static const List<String> chiList = [
    'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'
  ];

  static const List<String> starList = [
    'Thanh Long (Hoàng Đạo)',
    'Minh Đường (Hoàng Đạo)',
    'Thiên Hình (Hắc Đạo)',
    'Chu Tước (Hắc Đạo)',
    'Kim Quỹ (Hoàng Đạo)',
    'Kim Đường (Hoàng Đạo)',
    'Bạch Hổ (Hắc Đạo)',
    'Ngọc Đường (Hoàng Đạo)',
    'Thiên Lao (Hắc Đạo)',
    'Nguyên Vũ (Hắc Đạo)',
    'Tư Mệnh (Hoàng Đạo)',
    'Câu Trận (Hắc Đạo)',
  ];

  static const List<String> trucList = [
    'Kiến (Tốt cho khởi đầu, xuất hành)',
    'Trừ (Tốt cho giải trừ, chữa bệnh)',
    'Mãn (Tốt cho cầu tài, khai trương, cưới hỏi)',
    'Bình (Tốt cho sửa chữa, giao dịch bình an)',
    'Định (Tốt cho đính hôn, nhập trạch, ký kết)',
    'Chấp (Tốt cho gieo trồng, bắt đầu công việc)',
    'Phá (Nên kiêng việc lớn, chỉ tốt dỡ bỏ)',
    'Nguy (Nên kiêng khởi công, đi thuyền bè)',
    'Thành (Rất tốt cho cưới hỏi, khai trương, thi cử)',
    'Thâu (Tốt cho thu nợ, tích trữ tài lộc)',
    'Khai (Tốt cho mở cửa hàng, động thổ, cưới hỏi)',
    'Bế (Nên kiêng xuất hành, khai trương, động thổ)',
  ];

  static const List<String> tietKhiList = [
    'Xuân Phân', 'Thanh Minh', 'Cốc Vũ', 'Lập Hạ',
    'Tiểu Mãn', 'Mang Chủng', 'Hạ Chí', 'Tiểu Thử',
    'Đại Thử', 'Lập Thu', 'Xử Thử', 'Bạch Lộ',
    'Thu Phân', 'Hàn Lộ', 'Sương Giáng', 'Lập Đông',
    'Tiểu Tuyết', 'Đại Tuyết', 'Đông Chí', 'Tiểu Hàn',
    'Đại Hàn', 'Lập Xuân', 'Vũ Thủy', 'Kinh Trập',
  ];

  /// Tính số ngày Julius từ ngày Dương lịch
  static int jdFromDate(int dd, int mm, int yy) {
    int a = ((14 - mm) / 12).floor();
    int y = yy + 4800 - a;
    int m = mm + 12 * a - 3;
    int jd = dd +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
    if (jd < 2299161) {
      jd = dd +
          ((153 * m + 2) / 5).floor() +
          365 * y +
          (y / 4).floor() -
          32083;
    }
    return jd;
  }

  /// Tính ngày Sóc (New Moon) theo Jean Meeus
  static double _newMoon(int k) {
    double t = k / 1236.85;
    double t2 = t * t;
    double t3 = t2 * t;
    double dr = math.pi / 180.0;
    double jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * t2 - 0.000000155 * t3;
    jd1 += 0.00033 * math.sin((166.56 + 132.87 * t - 0.009173 * t2) * dr);
    double m = 359.2242 + 29.10535608 * k - 0.0000333 * t2 - 0.00000347 * t3;
    double mpr = 306.0253 + 385.81691806 * k + 0.0107306 * t2 + 0.00001236 * t3;
    double f = 21.2964 + 390.67050646 * k - 0.0016528 * t2 - 0.00000239 * t3;
    double c1 = (0.1734 - 0.000393 * t) * math.sin(m * dr) + 0.0021 * math.sin(2 * dr * m);
    c1 = c1 - 0.4068 * math.sin(mpr * dr) + 0.0161 * math.sin(dr * 2 * mpr);
    c1 = c1 - 0.0004 * math.sin(dr * 3 * mpr);
    c1 = c1 + 0.0104 * math.sin(dr * 2 * f) - 0.0051 * math.sin(dr * (m + mpr));
    c1 = c1 - 0.0074 * math.sin(dr * (m - mpr)) + 0.0004 * math.sin(dr * (2 * f + m));
    c1 = c1 - 0.0004 * math.sin(dr * (2 * f - m)) - 0.0006 * math.sin(dr * (2 * f + mpr));
    c1 = c1 + 0.0010 * math.sin(dr * (2 * f - mpr)) + 0.0005 * math.sin(dr * (2 * mpr + m));
    double delta;
    if (t < -11) {
      delta = 0.001 + 0.000839 * t + 0.0002261 * t2 - 0.00000845 * t3 - 0.000000081 * t * t3;
    } else {
      delta = -0.000278 + 0.000265 * t + 0.000262 * t2;
    }
    return jd1 + c1 - delta;
  }

  /// Tính kinh độ Mặt Trời (Sun Longitude)
  static double _sunLongitude(double jdn) {
    double t = (jdn - 2451545.0) / 36525.0;
    double t2 = t * t;
    double dr = math.pi / 180.0;
    double m = 357.52910 + 35999.05030 * t - 0.0001559 * t2 - 0.00000048 * t * t2;
    double l0 = 280.46645 + 36000.76983 * t + 0.0003032 * t2;
    double dl = (1.914600 - 0.004817 * t - 0.000014 * t2) * math.sin(dr * m);
    dl += (0.019993 - 0.000101 * t) * math.sin(dr * 2 * m) + 0.000290 * math.sin(dr * 3 * m);
    double l = (l0 + dl) * dr;
    l = l - math.pi * 2 * (l / (math.pi * 2)).floor();
    return l;
  }

  static int _getSunLongitude(int dayNumber) {
    return (_sunLongitude(dayNumber - 0.5 - timeZone / 24.0) / math.pi * 6).floor();
  }

  static int _getNewMoonDay(int k) {
    return (_newMoon(k) + 0.5 + timeZone / 24.0).floor();
  }

  static int _getLunarMonth11(int yy) {
    double off = jdFromDate(31, 12, yy) - 2415021.0;
    int k = (off / newMoonCycle).floor();
    int nm = _getNewMoonDay(k);
    int sunLong = _getSunLongitude(nm);
    if (sunLong >= 9) {
      nm = _getNewMoonDay(k - 1);
    }
    return nm;
  }

  static int _getLeapMonthOffset(int a11) {
    int k = ((a11 - juliusDaysIn1900) / newMoonCycle + 0.5).floor();
    int last = 0;
    int i = 1;
    int arc = _getSunLongitude(_getNewMoonDay(k + i));
    do {
      last = arc;
      i++;
      arc = _getSunLongitude(_getNewMoonDay(k + i));
    } while (arc != last && i < 14);
    return i - 1;
  }

  /// Chuyển đổi Ngày Dương sang Ngày Âm
  /// Trả về [lunarDay, lunarMonth, lunarYear, isLeap (0 hoặc 1)]
  static List<int> convertSolar2Lunar(int dd, int mm, int yy) {
    int dayNumber = jdFromDate(dd, mm, yy);
    int k = ((dayNumber - juliusDaysIn1900) / newMoonCycle).floor();
    int monthStart = _getNewMoonDay(k + 1);
    if (monthStart > dayNumber) {
      monthStart = _getNewMoonDay(k);
    }
    int a11 = _getLunarMonth11(yy);
    int b11 = a11;
    int lunarYear;
    if (a11 >= monthStart) {
      lunarYear = yy;
      a11 = _getLunarMonth11(yy - 1);
    } else {
      lunarYear = yy + 1;
      b11 = _getLunarMonth11(yy + 1);
    }
    int lunarDay = dayNumber - monthStart + 1;
    int diff = (monthStart - a11) ~/ 29;
    int lunarLeap = 0;
    int lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
      int leapMonthDiff = _getLeapMonthOffset(a11);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 10;
        if (diff == leapMonthDiff) {
          lunarLeap = 1;
        }
      }
    }
    if (lunarMonth > 12) {
      lunarMonth -= 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }
    return [lunarDay, lunarMonth, lunarYear, lunarLeap];
  }

  /// Tính Can Chi của Ngày từ JD
  static Map<String, dynamic> getCanChiDay(int jd) {
    int canIndex = (jd + 9) % 10;
    int chiIndex = (jd + 1) % 12;
    return {
      'canIndex': canIndex,
      'chiIndex': chiIndex,
      'name': '${canList[canIndex]} ${chiList[chiIndex]}',
    };
  }

  /// Tính Can Chi của Tháng
  static String getCanChiMonth(int lunarMonth, int lunarYear) {
    int yearCanIndex = (lunarYear + 6) % 10;
    int monthCanIndex = (yearCanIndex * 2 + lunarMonth + 1) % 10;
    int monthChiIndex = (lunarMonth + 1) % 12;
    return '${canList[monthCanIndex]} ${chiList[monthChiIndex]}';
  }

  /// Tính Can Chi của Năm
  static String getCanChiYear(int lunarYear) {
    int yearCanIndex = (lunarYear + 6) % 10;
    int yearChiIndex = (lunarYear + 8) % 12;
    return '${canList[yearCanIndex]} ${chiList[yearChiIndex]}';
  }

  /// Kiểm tra Ngày Hoàng Đạo / Hắc Đạo
  static Map<String, dynamic> getHoangDaoDayInfo(int lunarMonth, int dayChiIndex) {
    const Map<int, int> startChiMap = {
      1: 0, 7: 0,   // Tháng 1, 7 khởi Thanh Long tại Tý (0)
      2: 2, 8: 2,   // Tháng 2, 8 khởi Thanh Long tại Dần (2)
      3: 4, 9: 4,   // Tháng 3, 9 khởi Thanh Long tại Thìn (4)
      4: 6, 10: 6,  // Tháng 4, 10 khởi Thanh Long tại Ngọ (6)
      5: 8, 11: 8,  // Tháng 5, 11 khởi Thanh Long tại Thân (8)
      6: 10, 12: 10 // Tháng 6, 12 khởi Thanh Long tại Tuất (10)
    };

    int startChi = startChiMap[lunarMonth] ?? 0;
    int offset = (dayChiIndex - startChi + 12) % 12;
    // Hoàng Đạo: offset 0, 1, 4, 5, 7, 10
    const Set<int> hoangDaoOffsets = {0, 1, 4, 5, 7, 10};
    bool isHoangDao = hoangDaoOffsets.contains(offset);
    String star = starList[offset];

    return {
      'isHoangDao': isHoangDao,
      'star': star,
    };
  }

  /// Tính 12 Trực
  static String getTruc(int lunarMonth, int dayChiIndex) {
    // Chi của tháng âm: Tháng 1 là Dần (2), Tháng 2 là Mão (3)...
    int monthChiIndex = (lunarMonth + 1) % 12;
    // Trực Kiến bắt đầu khi dayChiIndex == monthChiIndex
    int trucIndex = (dayChiIndex - monthChiIndex + 12) % 12;
    return trucList[trucIndex];
  }

  /// Tính Tiết Khí
  static String getTietKhi(int jd) {
    double sunLong = _sunLongitude(jd - 0.5 - timeZone / 24.0);
    int tietKhiIndex = ((sunLong * 180.0 / math.pi) / 15.0).floor() % 24;
    return tietKhiList[tietKhiIndex];
  }

  /// Tính Giờ Hoàng Đạo trong ngày
  static List<String> getHoangDaoHours(int dayChiIndex) {
    // Khởi giờ Thanh Long theo Chi ngày
    int startHourChi;
    switch (dayChiIndex) {
      case 2: case 8: // Dần, Thân -> Tý
        startHourChi = 0; break;
      case 3: case 9: // Mão, Dậu -> Dần
        startHourChi = 2; break;
      case 4: case 10: // Thìn, Tuất -> Thìn
        startHourChi = 4; break;
      case 5: case 11: // Tỵ, Hợi -> Ngọ
        startHourChi = 6; break;
      case 0: case 6: // Tý, Ngọ -> Thân
        startHourChi = 8; break;
      default: // Sửu, Mùi -> Tuất
        startHourChi = 10; break;
    }

    const Set<int> hoangDaoOffsets = {0, 1, 4, 5, 7, 10};
    const List<String> hourTimeFrames = [
      'Tý (23-01h)', 'Sửu (01-03h)', 'Dần (03-05h)', 'Mão (05-07h)',
      'Thìn (07-09h)', 'Tỵ (09-11h)', 'Ngọ (11-13h)', 'Mùi (13-15h)',
      'Thân (15-17h)', 'Dậu (17-19h)', 'Tuất (19-21h)', 'Hợi (21-23h)',
    ];

    List<String> result = [];
    for (int h = 0; h < 12; h++) {
      int offset = (h - startHourChi + 12) % 12;
      if (hoangDaoOffsets.contains(offset)) {
        result.add(hourTimeFrames[h]);
      }
    }
    return result;
  }

  /// Hướng Xuất Hành (Hỷ Thần, Tài Thần)
  static Map<String, String> getDirections(int dayCanIndex) {
    switch (dayCanIndex) {
      case 0: case 5: // Giáp, Kỷ
        return {'hyThan': 'Đông Bắc', 'taiThan': 'Chính Nam'};
      case 1: case 6: // Ất, Canh
        return {'hyThan': 'Tây Bắc', 'taiThan': 'Tây Nam'};
      case 2: case 7: // Bính, Tân
        return {'hyThan': 'Tây Nam', 'taiThan': 'Chính Tây'};
      case 3: case 8: // Đinh, Nhâm
        return {'hyThan': 'Chính Nam', 'taiThan': 'Tây Bắc'};
      default: // Mậu, Quý
        return {'hyThan': 'Đông Nam', 'taiThan': 'Chính Bắc'};
    }
  }

  /// Tuổi Xung Ngày
  static String getXungTuoi(int dayChiIndex, int dayCanIndex) {
    // Chi Lục Xung
    int xungChi = (dayChiIndex + 6) % 12;
    // Can Tương Khắc
    int khacCan = (dayCanIndex + 4) % 10;
    int khacCan2 = (dayCanIndex + 6) % 10;
    return '${canList[khacCan]} ${chiList[xungChi]}, ${canList[khacCan2]} ${chiList[xungChi]}';
  }

  /// Việc nên làm & kiêng cử
  static Map<String, List<String>> getGoodBadActivities(bool isHoangDao, int trucIndex) {
    List<String> good = [];
    List<String> bad = [];

    if (isHoangDao) {
      good.addAll(['Xuất hành', 'Cúng tế', 'Giao dịch', 'Ký kết', 'Cầu phúc']);
    } else {
      bad.addAll(['Khởi công', 'Động thổ', 'Đại sự quan trọng']);
    }

    switch (trucIndex) {
      case 0: // Kiến
        good.addAll(['Khởi sự', 'Nhập học', 'Cầu tài']);
        bad.addAll(['Động thổ', 'Đào giếng']);
        break;
      case 1: // Trừ
        good.addAll(['Chữa bệnh', 'Tắm gội giải trừ', 'Vệ sinh nhà cửa']);
        bad.addAll(['Cưới hỏi', 'Khai trương']);
        break;
      case 2: // Mãn
        good.addAll(['Cưới hỏi', 'Khai trương', 'Nhập kho', 'Cầu tài']);
        bad.addAll(['Chữa bệnh', 'Tranh chấp kiện tụng']);
        break;
      case 3: // Bình
        good.addAll(['Sửa chữa', 'Giao dịch', 'Trồng trọt']);
        bad.addAll(['Đi thuyền mạo hiểm']);
        break;
      case 4: // Định
        good.addAll(['Đính hôn', 'Ký hợp đồng', 'Mua bán nhà đất']);
        bad.addAll(['Tranh chấp kiện tụng']);
        break;
      case 5: // Chấp
        good.addAll(['Gieo trồng', 'Xây đắp', 'Săn bắt']);
        bad.addAll(['Mở kho xuất tiền', 'Di chuyển xa']);
        break;
      case 6: // Phá
        good.addAll(['Phá dỡ nhà cũ', 'Chữa bệnh']);
        bad.addAll(['Cưới gả', 'Khai trương', 'Xây dựng']);
        break;
      case 7: // Nguy
        good.addAll(['Làm việc từ thiện', 'Cúng bái tổ tiên']);
        bad.addAll(['Leo núi', 'Đi thuyền', 'Động thổ']);
        break;
      case 8: // Thành
        good.addAll(['Cưới hỏi', 'Khai trương', 'Ký hợp đồng', 'Nhập trạch']);
        bad.addAll(['Tranh chấp kiện tụng']);
        break;
      case 9: // Thâu
        good.addAll(['Thu nợ', 'Gặt hái', 'Mua sắm tích trữ']);
        bad.addAll(['Xuất hành đi xa', 'Tang lễ']);
        break;
      case 10: // Khai
        good.addAll(['Khai trương', 'Mở kho', 'Cưới hỏi', 'Động thổ']);
        bad.addAll(['Chôn cất', 'Phá dỡ']);
        break;
      case 11: // Bế
        good.addAll(['Đắp đập', 'Vá tường', 'An táng']);
        bad.addAll(['Khai trương', 'Cưới hỏi', 'Xuất hành']);
        break;
    }

    return {
      'good': good.toSet().toList(),
      'bad': bad.toSet().toList(),
    };
  }

  /// Lấy toàn bộ thông tin ngày Âm lịch và Phong thủy
  static LunarDate getFullLunarDate(DateTime solarDate) {
    int dd = solarDate.day;
    int mm = solarDate.month;
    int yy = solarDate.year;

    List<int> lunar = convertSolar2Lunar(dd, mm, yy);
    int lDay = lunar[0];
    int lMonth = lunar[1];
    int lYear = lunar[2];
    bool isLeap = lunar[3] == 1;

    int jd = jdFromDate(dd, mm, yy);
    Map<String, dynamic> canChiDayInfo = getCanChiDay(jd);
    int dayCanIdx = canChiDayInfo['canIndex'] as int;
    int dayChiIdx = canChiDayInfo['chiIndex'] as int;
    String canChiDay = canChiDayInfo['name'] as String;

    String canChiMonth = getCanChiMonth(lMonth, lYear);
    String canChiYear = getCanChiYear(lYear);

    Map<String, dynamic> hoangDaoInfo = getHoangDaoDayInfo(lMonth, dayChiIdx);
    bool isHoangDao = hoangDaoInfo['isHoangDao'] as bool;
    String hoangDaoStar = hoangDaoInfo['star'] as String;

    // Chi của tháng âm
    int monthChiIndex = (lMonth + 1) % 12;
    int trucIdx = (dayChiIdx - monthChiIndex + 12) % 12;
    String truc = trucList[trucIdx];

    String tietKhi = getTietKhi(jd);
    List<String> hoangDaoHours = getHoangDaoHours(dayChiIdx);
    Map<String, String> directions = getDirections(dayCanIdx);
    String xungTuoi = getXungTuoi(dayChiIdx, dayCanIdx);
    Map<String, List<String>> activities = getGoodBadActivities(isHoangDao, trucIdx);

    return LunarDate(
      solarDay: dd,
      solarMonth: mm,
      solarYear: yy,
      lunarDay: lDay,
      lunarMonth: lMonth,
      lunarYear: lYear,
      isLeapMonth: isLeap,
      canChiDay: canChiDay,
      canChiMonth: canChiMonth,
      canChiYear: canChiYear,
      isHoangDao: isHoangDao,
      hoangDaoStar: hoangDaoStar,
      truc: truc,
      tietKhi: tietKhi,
      hoangDaoHours: hoangDaoHours,
      hyThanDirection: directions['hyThan']!,
      taiThanDirection: directions['taiThan']!,
      goodFor: activities['good']!,
      badFor: activities['bad']!,
      xungTuoi: xungTuoi,
    );
  }
}
