export interface BaguaPalace {
  id: string;
  name: string;
  han: string;
  symbol: string;
  binary: string;
  nature: string;
  element: string;
  direction: string;
  degrees: string;
  family: string;
  body: string;
  number: number;
  group: 'Đông Tứ Mệnh' | 'Tây Tứ Mệnh';
  color: string;
  goodDirs: Array<{ name: string; dir: string; desc: string }>;
  badDirs: Array<{ name: string; dir: string; desc: string }>;
  desc: string;
}

export interface LuBanSector {
  name: string;
  isGood: boolean;
  desc: string;
}

export interface LuBanRuler {
  type: string;
  name: string;
  usage: string;
  unitLength: number;
  sectors: LuBanSector[];
}

export interface IChingHexagram {
  number: number;
  name: string;
  upper: string;
  lower: string;
  symbol: string;
  meaning: string;
  fengShui: string;
}

export interface SatKhiItem {
  name: string;
  danger: string;
  solution: string;
}

export const BAGUA_PALACES: BaguaPalace[] = [
  {
    id: "can",
    name: "Càn",
    han: "乾",
    symbol: "☰",
    binary: "111",
    nature: "Thiên (Trời)",
    element: "Kim (Dương Kim)",
    direction: "Tây Bắc",
    degrees: "292.5° - 337.5°",
    family: "Cha, Trưởng bối, Người đứng đầu",
    body: "Đầu, Não, Xương, Phổi",
    number: 6,
    group: "Tây Tứ Mệnh",
    color: "Trắng, Bạc, Vàng kim",
    goodDirs: [
      { name: "Sinh Khí", dir: "Tây (Đoài)", desc: "Đại cát, sinh tài tiến bảo, thăng quan tiến chức" },
      { name: "Thiên Y", dir: "Đông Bắc (Cấn)", desc: "Trường thọ, quý nhân phù trợ, sức khỏe dồi dào" },
      { name: "Diên Niên", dir: "Tây Nam (Khôn)", desc: "Hòa thuận gia đạo, hôn nhân bền chặt, phúc đức" },
      { name: "Phục Vị", dir: "Tây Bắc (Càn)", desc: "Bình yên, tăng cường nghị lực, củng cố bản thân" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Nam (Ly)", desc: "Đại hung, tổn hại nhân đinh, bệnh tật tai ách" },
      { name: "Ngũ Quỷ", dir: "Đông (Chấn)", desc: "Hỏa hoạn, trộm cướp, thị phi khẩu thiệt, hao tài" },
      { name: "Lục Sát", dir: "Bắc (Khảm)", desc: "Kiện tụng, tình duyên lận đận, tai nạn sông nước" },
      { name: "Họa Hại", dir: "Đông Nam (Tốn)", desc: "Thị phi, tiểu nhân quấy phá, bất hòa nội bộ" }
    ],
    desc: "Quẻ Càn thuần dương chí cương, biểu trưng cho quyền lực, sự cương trực và tôn quý. Trong nhà, phương Tây Bắc đại diện cho vị thế gia chủ nam giới, cần đặt phòng làm việc, phòng thờ tôn nghiêm, kỵ đặt nhà vệ sinh hoặc bếp lửa thiêu đốt cung Càn (Hỏa khắc Kim)."
  },
  {
    id: "kham",
    name: "Khảm",
    han: "坎",
    symbol: "☵",
    binary: "010",
    nature: "Thủy (Nước)",
    element: "Thủy (Dương Thủy)",
    direction: "Chính Bắc",
    degrees: "337.5° - 22.5°",
    family: "Trung nam (Con trai thứ)",
    body: "Thận, Tai, Bàng quang, Máu huyết",
    number: 1,
    group: "Đông Tứ Mệnh",
    color: "Đen, Xanh lam, Xanh nước biển",
    goodDirs: [
      { name: "Sinh Khí", dir: "Đông Nam (Tốn)", desc: "Tài vận hanh thông, công danh rực rỡ" },
      { name: "Thiên Y", dir: "Đông (Chấn)", desc: "Thân tâm an lạc, tiêu trừ tai ách, gặp quý nhân" },
      { name: "Diên Niên", dir: "Nam (Ly)", desc: "Thủy Hỏa ký tế, gia đình vạn sự viên mãn" },
      { name: "Phục Vị", dir: "Bắc (Khảm)", desc: "Vững bền, trí tuệ sáng suốt, học hành đỗ đạt" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Tây Nam (Khôn)", desc: "Thổ khắc Thủy, tổn hại sức khỏe, tài lộc lụi tàn" },
      { name: "Ngũ Quỷ", dir: "Đông Bắc (Cấn)", desc: "Tổn thương xương khớp, tiểu nhân ám hại" },
      { name: "Lục Sát", dir: "Tây Bắc (Càn)", desc: "Bất hòa tình duyên, tinh thần bất an" },
      { name: "Họa Hại", dir: "Tây (Đoài)", desc: "Khẩu thiệt tranh đoạt, việc làm khó thành" }
    ],
    desc: "Quẻ Khảm là biểu trưng của sự huyền diệu, trí tuệ sâu sắc và tính thích nghi uyển chuyển. Khảm thuộc hướng Bắc, chủ về danh vọng học vấn và sự bền bỉ. Hướng này cần thông thoáng, sáng sủa, tránh tụ uế khí."
  },
  {
    id: "can_tho",
    name: "Cấn",
    han: "艮",
    symbol: "☶",
    binary: "001",
    nature: "Sơn (Núi)",
    element: "Thổ (Dương Thổ)",
    direction: "Đông Bắc",
    degrees: "22.5° - 67.5°",
    family: "Thiếu nam (Con trai út)",
    body: "Lưng, Cột sống, Ngón tay, Dạ dày",
    number: 8,
    group: "Tây Tứ Mệnh",
    color: "Vàng, Nâu đất, Cam đất",
    goodDirs: [
      { name: "Sinh Khí", dir: "Tây Nam (Khôn)", desc: "Điền sản phát đạt, gia nghiệp vững vàng" },
      { name: "Thiên Y", dir: "Tây Bắc (Càn)", desc: "Gặp thầy gặp thuốc, tuổi thọ an khang" },
      { name: "Diên Niên", dir: "Tây (Đoài)", desc: "Vui vẻ hòa thuận, sinh con thông minh" },
      { name: "Phục Vị", dir: "Đông Bắc (Cấn)", desc: "Điềm tĩnh, trí tuệ kiên định, sự nghiệp vững" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Đông Nam (Tốn)", desc: "Mộc khắc Thổ, tổn hao tài bảo, đoản thọ" },
      { name: "Ngũ Quỷ", dir: "Bắc (Khảm)", desc: "Hao tán tiền của, trộm cắp quấy phá" },
      { name: "Lục Sát", dir: "Đông (Chấn)", desc: "Xung đột gia đình, kiện cáo tranh giành" },
      { name: "Họa Hại", dir: "Nam (Ly)", desc: "Bệnh tật nhiệt độc, tai bay vạ gió" }
    ],
    desc: "Quẻ Cấn tượng trưng cho núi non tĩnh lặng, sự bảo bọc và ngưng tụ tài lộc. Đây là cung Quỷ Môn trong phong thủy, phương Đông Bắc cần tĩnh lặng, kiên cố, không nên mở cửa sau trống huếch."
  },
  {
    id: "chan",
    name: "Chấn",
    han: "震",
    symbol: "☳",
    binary: "100",
    nature: "Lôi (Sấm sét)",
    element: "Mộc (Dương Mộc)",
    direction: "Chính Đông",
    degrees: "67.5° - 112.5°",
    family: "Trưởng nam (Con trai cả)",
    body: "Gan, Mật, Chân, Dây thần kinh",
    number: 3,
    group: "Đông Tứ Mệnh",
    color: "Xanh lục, Xanh lá chuối, Xanh ngọc",
    goodDirs: [
      { name: "Sinh Khí", dir: "Nam (Ly)", desc: "Mộc Hỏa tương sinh, tài lộc phát vượng rực rỡ" },
      { name: "Thiên Y", dir: "Bắc (Khảm)", desc: "Thủy dưỡng Mộc, quý nhân nâng đỡ, trường thọ" },
      { name: "Diên Niên", dir: "Đông Nam (Tốn)", desc: "Huynh đệ hòa thuận, hạnh phúc lứa đôi" },
      { name: "Phục Vị", dir: "Đông (Chấn)", desc: "Năng động dũng cảm, thăng tiến sự nghiệp" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Tây (Đoài)", desc: "Kim khắc Mộc, tổn thương gân cốt, hao tán tài" },
      { name: "Ngũ Quỷ", dir: "Tây Bắc (Càn)", desc: "Phạm thượng, kiện tụng, thất thoát tài sản lớn" },
      { name: "Lục Sát", dir: "Đông Bắc (Cấn)", desc: "Thất bại trong tình cảm, thị phi bủa vây" },
      { name: "Họa Hại", dir: "Tây Nam (Khôn)", desc: "Bệnh tật tiêu hóa, khẩu thiệt thị phi" }
    ],
    desc: "Quẻ Chấn là nguồn năng lượng của mùa xuân, tiếng sấm khởi phát muôn loài. Hướng Đông là phương của sinh cơ và sự nghiệp khởi đầu, rất tốt để đặt phòng làm việc người trẻ tuổi hoặc trồng cây xanh tươi tốt."
  },
  {
    id: "ton",
    name: "Tốn",
    han: "巽",
    symbol: "☴",
    binary: "011",
    nature: "Phong (Gió), Mộc (Cây cối)",
    element: "Mộc (Âm Mộc)",
    direction: "Đông Nam",
    degrees: "112.5° - 157.5°",
    family: "Trưởng nữ (Con gái cả)",
    body: "Đùi, Ruột, Hông, Hệ hô hấp",
    number: 4,
    group: "Đông Tứ Mệnh",
    color: "Xanh lục nhạt, Xanh lục thẫm",
    goodDirs: [
      { name: "Sinh Khí", dir: "Bắc (Khảm)", desc: "Thủy sinh Mộc, tài trí phi phàm, tiền của sung túc" },
      { name: "Thiên Y", dir: "Nam (Ly)", desc: "Mộc sinh Hỏa, danh tiếng vang xa, an khang" },
      { name: "Diên Niên", dir: "Đông (Chấn)", desc: "Gia đình sum vầy, sự nghiệp phát triển vững bền" },
      { name: "Phục Vị", dir: "Đông Nam (Tốn)", desc: "Khéo léo, duyên dáng, văn chương nghệ thuật thăng hoa" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Đông Bắc (Cấn)", desc: "Tổn thương nhân khẩu, công việc trắc trở" },
      { name: "Ngũ Quỷ", dir: "Tây Nam (Khôn)", desc: "Bệnh tật kéo dài, hao tài tốn của" },
      { name: "Lục Sát", dir: "Tây (Đoài)", desc: "Kim phạt Mộc, thị phi tình duyên, khẩu thiệt" },
      { name: "Họa Hại", dir: "Tây Bắc (Càn)", desc: "Xung khắc cấp trên, mưu sự bất thành" }
    ],
    desc: "Quẻ Tốn mềm mại như ngọn gió lành, chủ về giao tiếp, tài ngoại giao và vận may tiền tài. Cung Đông Nam trong phong thủy bát trạch được coi là Cung Tài Lộc tối quan trọng của ngôi nhà."
  },
  {
    id: "ly",
    name: "Ly",
    han: "離",
    symbol: "☲",
    binary: "101",
    nature: "Hỏa (Lửa), Nhật (Mặt trời)",
    element: "Hỏa (Âm Hỏa)",
    direction: "Chính Nam",
    degrees: "157.5° - 202.5°",
    family: "Trung nữ (Con gái thứ)",
    body: "Tim, Mắt, Huyết mạch, Não bộ",
    number: 9,
    group: "Đông Tứ Mệnh",
    color: "Đỏ, Hồng, Tím, Cam rực",
    goodDirs: [
      { name: "Sinh Khí", dir: "Đông (Chấn)", desc: "Mộc dưỡng Hỏa, đại phú đại quý, công danh rực rỡ" },
      { name: "Thiên Y", dir: "Đông Nam (Tốn)", desc: "Thần linh bảo trợ, tinh thần minh mẫn, sống lâu" },
      { name: "Diên Niên", dir: "Bắc (Khảm)", desc: "Thủy Hỏa tương tễ, vợ chồng hòa thuận, ấm êm" },
      { name: "Phục Vị", dir: "Nam (Ly)", desc: "Văn chương xán lạn, tiếng tăm lẫy lừng" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Tây Bắc (Càn)", desc: "Hỏa thiêu Thiên môn, bệnh tim mạch, đại nạn" },
      { name: "Ngũ Quỷ", dir: "Tây (Đoài)", desc: "Hỏa thiêu Phế kim, thị phi, tranh chấp đất đai" },
      { name: "Lục Sát", dir: "Tây Nam (Khôn)", desc: "Mẹ con bất hòa, trắc trở đường tình cảm" },
      { name: "Họa Hại", dir: "Đông Bắc (Cấn)", desc: "Khẩu thiệt, tiêu hao của cải, việc khó trôi chảy" }
    ],
    desc: "Quẻ Ly tượng trưng cho ánh sáng soi rọi, văn minh, công danh sự nghiệp và danh vọng. Hướng Nam là phương vị đón ánh mặt trời tốt nhất của văn hóa Việt Nam ('Lấy vợ hiền hòa, làm nhà hướng Nam')."
  },
  {
    id: "khon",
    name: "Khôn",
    han: "坤",
    symbol: "☷",
    binary: "000",
    nature: "Địa (Đất)",
    element: "Thổ (Âm Thổ)",
    direction: "Tây Nam",
    degrees: "202.5° - 247.5°",
    family: "Mẹ, Nữ chủ nhân, Người già cả",
    body: "Bụng, Dạ dày, Tỳ vị, Da thịt",
    number: 2,
    group: "Tây Tứ Mệnh",
    color: "Vàng đất, Nâu, Xám tro",
    goodDirs: [
      { name: "Sinh Khí", dir: "Đông Bắc (Cấn)", desc: "Thổ Thổ tương phùng, tích lũy đất đai tiền bạc" },
      { name: "Thiên Y", dir: "Tây (Đoài)", desc: "Thổ sinh Kim, con cháu thông tuệ, sức khỏe dồi dào" },
      { name: "Diên Niên", dir: "Tây Bắc (Càn)", desc: "Âm Dương tương phối, gia đình hạnh phúc bền lâu" },
      { name: "Phục Vị", dir: "Tây Nam (Khôn)", desc: "Bao dung nhân từ, gia sản vững chắc" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Bắc (Khảm)", desc: "Thổ khắc Thủy, đường ruột bệnh tật, nhân khẩu suy thoái" },
      { name: "Ngũ Quỷ", dir: "Đông Nam (Tốn)", desc: "Mộc hại Thổ, hao tán sản nghiệp, ốm đau triền miên" },
      { name: "Lục Sát", dir: "Nam (Ly)", desc: "Hỏa Thổ khô khan, tranh cãi bất an, tình cảm rạn nứt" },
      { name: "Họa Hại", dir: "Đông (Chấn)", desc: "Mộc kích Thổ, tổn thương tỳ vị, mưu sự bất thành" }
    ],
    desc: "Quẻ Khôn thuần âm nhu thuận, tượng trưng cho Đất mẹ chở che, đức dày nuôi dưỡng vạn vật. Phương Tây Nam đại diện cho nữ gia chủ và tài lộc tích lũy, tối kỵ bị khuyết góc hoặc u ám ẩm thấp."
  },
  {
    id: "doai",
    name: "Đoài",
    han: "兌",
    symbol: "☱",
    binary: "011",
    nature: "Trạch (Đầm nước)",
    element: "Kim (Âm Kim)",
    direction: "Chính Tây",
    degrees: "247.5° - 292.5°",
    family: "Thiếu nữ (Con gái út)",
    body: "Miệng, Răng, Họng, Phổi",
    number: 7,
    group: "Tây Tứ Mệnh",
    color: "Trắng, Bạc, Ghi, Ánh kim",
    goodDirs: [
      { name: "Sinh Khí", dir: "Tây Bắc (Càn)", desc: "Kim Kim đồng khí, phát đạt nhanh chóng, danh vọng cao" },
      { name: "Thiên Y", dir: "Tây Nam (Khôn)", desc: "Thổ sinh Kim, sống lâu không bệnh tật, quý nhân giúp" },
      { name: "Diên Niên", dir: "Đông Bắc (Cấn)", desc: "Thổ dưỡng Kim, tài lộc tích tụ, vợ chồng tâm đầu ý hợp" },
      { name: "Phục Vị", dir: "Tây (Đoài)", desc: "Vui vẻ lạc quan, ăn nói có duyên, tài năng đỗ đạt" }
    ],
    badDirs: [
      { name: "Tuyệt Mệnh", dir: "Đông (Chấn)", desc: "Kim Mộc tương tàn, tai nạn thương tích, đoản mệnh" },
      { name: "Ngũ Quỷ", dir: "Nam (Ly)", desc: "Hỏa thiêu Kim tàn, hỏa hoạn, thị phi khẩu nghiệp" },
      { name: "Lục Sát", dir: "Đông Nam (Tốn)", desc: "Đào hoa sát, tình duyên đứt gánh, bất an" },
      { name: "Họa Hại", dir: "Bắc (Khảm)", desc: "Kim chìm đáy nước, khẩu thiệt, lừa gạt tiền bạc" }
    ],
    desc: "Quẻ Đoài tượng trưng cho sự hỷ lạc, đầm sen thanh mát, tài hùng biện và ngoại giao. Hướng Tây trong phong thủy chủ về con cái, sự thịnh vượng hậu vận và các mối quan hệ xã hội."
  }
];

export const LUBAN_RULERS: LuBanRuler[] = [
  {
    type: "522",
    name: "Thước Lỗ Ban 52.2 cm",
    usage: "Đo Thông Thủy (Khoảng lọt sáng: Cửa chính, cửa sổ, giếng trời, chiều cao lọt lòng trần)",
    unitLength: 52.2,
    sectors: [
      { name: "Quý Nhân", isGood: true, desc: "Gặp quý nhân tương trợ, làm ăn phát đạt, con cái thông minh" },
      { name: "Hiểm Họa", isGood: false, desc: "Tai họa bất ngờ, gia đạo bất hòa, phá sản, phiền não" },
      { name: "Thiên Tai", isGood: false, desc: "Ốm đau liên miên, bệnh tật hiểm nghèo, chết chóc" },
      { name: "Thiên Tài", isGood: true, desc: "Tài lộc tự nhiên đến, may mắn ngập tràn, vạn sự đắc lợi" },
      { name: "Nhân Lộc", isGood: true, desc: "Gia đình ấm no, con cháu đỗ đạt, phúc lộc trường tồn" },
      { name: "Cô Độc", isGood: false, desc: "Gia đình phân ly, đơn độc hiu quạnh, con cái bất hiếu" },
      { name: "Thiên Tặc", isGood: false, desc: "Trộm cắp cướp bóc, tai bay vạ gió, tù ngục kiện tụng" },
      { name: "Tể Tướng", isGood: true, desc: "Công danh hiển hách, thăng quan tiến chức, danh vọng vang dội" }
    ]
  },
  {
    type: "429",
    name: "Thước Lỗ Ban 42.9 cm",
    usage: "Đo Dương Trạch (Khối xây dựng đặc: Bệ bếp, bậc cầu thang, khuôn cửa, kích thước bàn ghế, tủ kệ)",
    unitLength: 42.9,
    sectors: [
      { name: "Tài", isGood: true, desc: "Được của cải, của đến chân tay, đón nhận điền sản cát lợi" },
      { name: "Bệnh", isGood: false, desc: "Ốm đau bệnh tật, tổn thất nhân đinh, thị phi tranh chấp" },
      { name: "Ly", isGood: false, desc: "Phân ly xa cách, gia đạo lộn xộn, hao tiền tốn của" },
      { name: "Nghĩa", isGood: true, desc: "Điều lành tới tấp, sinh quý tử, phước đức sâu dày" },
      { name: "Quan", isGood: true, desc: "Đỗ đạt làm quan, quý nhân phù trợ, tiền tài tấn tới" },
      { name: "Kiếp", isGood: false, desc: "Bị cướp bóc đoạt tài, chia lìa cốt nhục, họa hại" },
      { name: "Hại", isGood: false, desc: "Họa hại bất trắc, khẩu thiệt tranh cãi, tai ương" },
      { name: "Bản", isGood: true, desc: "Bản mệnh vững vàng, phát phúc sinh tài, mọi việc thuận lợi" }
    ]
  },
  {
    type: "388",
    name: "Thước Lỗ Ban 38.8 cm",
    usage: "Đo Âm Phần (Nội thất thờ cúng: Kích thước Bàn thờ, tủ thờ, sập thờ, tiểu quách, bia mộ)",
    unitLength: 38.8,
    sectors: [
      { name: "Đinh", isGood: true, desc: "Thêm con trai, phúc lộc sinh sôi, tài vận dồi dào" },
      { name: "Hại", isGood: false, desc: "Bệnh tật, tuyệt tự, tai nạn bất ngờ, chia lìa" },
      { name: "Vượng", isGood: true, desc: "Phát vượng giàu có, sinh con quý tử, đức độ hiển vinh" },
      { name: "Khổ", isGood: false, desc: "Gian truân vất vả, kiện tụng tù tội, hao tán tài sản" },
      { name: "Nghĩa", isGood: true, desc: "Đại cát đại lợi, gia môn hữu phước, con cháu thảo hiền" },
      { name: "Quan", isGood: true, desc: "Thăng quan tấn tước, thi cử đỗ đầu, tài lộc dồi dào" },
      { name: "Tử", isGood: false, desc: "Chết chóc tang tóc, mất mát lớn, gia sản tiêu vong" },
      { name: "Hưng", isGood: true, desc: "Hưng thịnh rạng rỡ, làm ăn đại phát, con cái thành đạt" },
      { name: "Thất", isGood: false, desc: "Thất thoát của cải, hao tài tốn lộc, tù tội oan ức" },
      { name: "Tài", isGood: true, desc: "Tiền tài tự đến, may mắn bất ngờ, gia đạo hưng long" }
    ]
  }
];

export const ICHING_HEXAGRAMS: IChingHexagram[] = [
  { number: 1, name: "Thuần Càn", upper: "Càn (Trời)", lower: "Càn (Trời)", symbol: "☰☰", meaning: "Nguyên hanh lợi trinh. Cương kiện quang minh, thời cơ đại thịnh, cần giữ lòng chính trực khiêm tốn.", fengShui: "Rất tốt cho công danh, phòng thờ và phòng làm việc gia chủ nam." },
  { number: 2, name: "Thuần Khôn", upper: "Khôn (Đất)", lower: "Khôn (Đất)", symbol: "☷☷", meaning: "Đức dày chở vật. Nhu thuận bao dung, kinh doanh điền sản đại lợi, tiến bước theo người dẫn đầu.", fengShui: "Thích hợp cho điền trang, nhà vườn, tích trữ của cải, dưỡng sinh." },
  { number: 3, name: "Thủy Lôi Truân", upper: "Khảm (Nước)", lower: "Chấn (Sấm)", symbol: "☵☳", meaning: "Vạn sự khởi đầu nan. Tích lũy tiềm lực, kiên nhẫn vượt khó, chớ hành động vội vã.", fengShui: "Nhà mới xây dựng cần củng cố móng vững chắc, tránh đổi dời liên tục." },
  { number: 4, name: "Sơn Thủy Mông", upper: "Cấn (Núi)", lower: "Khảm (Nước)", symbol: "☶☵", meaning: "Mờ mịt cần khai sáng. Cầu học thầy giỏi, khiêm nhường lắng nghe, sáng suốt định hướng.", fengShui: "Cần tăng cường ánh sáng hướng Bắc, đặt bàn học ở góc Văn Xương." },
  { number: 5, name: "Thủy Thiên Nhu", upper: "Khảm (Nước)", lower: "Càn (Trời)", symbol: "☵☰", meaning: "Chờ đợi thời cơ. Dưỡng sức chờ thời, ăn uống vui vẻ lạc quan, thời tới sẽ thành công.", fengShui: "Bố trí phòng khách ấm cúng, đón gió mát và ánh sáng hài hòa." },
  { number: 6, name: "Thiên Thủy Tụng", upper: "Càn (Trời)", lower: "Khảm (Nước)", symbol: "☰☵", meaning: "Tranh chấp kiện tụng. Lùi một bước trời cao biển rộng, dĩ hòa vi quý, tránh cố chấp.", fengShui: "Hóa giải cửa hai phòng đối diện nhau, bỏ gương soi chiếu thẳng cửa chính." },
  { number: 7, name: "Địa Thủy Sư", upper: "Khôn (Đất)", lower: "Khảm (Nước)", symbol: "☷☵", meaning: "Dấy quân xuất trận. Có kỷ luật trật tự, lòng người đồng thuận, lãnh đạo công minh.", fengShui: "Phòng làm việc cần nghiêm cẩn, bàn làm việc có điểm tựa vững vàng." },
  { number: 8, name: "Thủy Địa Tỷ", upper: "Khảm (Nước)", lower: "Khôn (Đất)", symbol: "☵☷", meaning: "Thân thiện gắn kết. Gần gũi người hiền, tương trợ lẫn nhau, hòa thuận tạo sinh tài.", fengShui: "Bố trí không gian sinh hoạt chung rộng mở, gắn kết tình cảm gia đình." },
  { number: 11, name: "Địa Thiên Thái", upper: "Khôn (Đất)", lower: "Càn (Trời)", symbol: "☷☰", meaning: "Trời đất giao hòa, vạn vật thái bình hanh thông. Đại cát đại lợi, thời vận hưng thịnh bậc nhất.", fengShui: "Tuyệt đỉnh phong thủy nhà ở, âm dương cân bằng, tài lộc thịnh vượng trường tồn." },
  { number: 12, name: "Thiên Địa Bĩ", upper: "Càn (Trời)", lower: "Khôn (Đất)", symbol: "☰☷", meaning: "Bế tắc chia lìa. Trời đất không giao thoa, kẻ tiểu nhân đắc chí, người quân tử nên giữ mình.", fengShui: "Cảnh báo luồng khí trong nhà bị ngưng trệ, cần mở rộng cửa lấy gió tươi thông thoáng." },
  { number: 14, name: "Hỏa Thiên Đại Hữu", upper: "Ly (Lửa)", lower: "Càn (Trời)", symbol: "☲☰", meaning: "Mặt trời rực sáng giữa trời cao. Có được của cải lớn lao, phú quý vinh hiển.", fengShui: "Phòng khách và sảnh chính rực rỡ ánh sáng, tăng cường vượng khí tài lộc." },
  { number: 15, name: "Địa Sơn Khiêm", upper: "Khôn (Đất)", lower: "Cấn (Núi)", symbol: "☷☶", meaning: "Núi cao ở dưới đất thấp. Khiêm nhường đức độ, được người người kính nể, bình an trọn vẹn.", fengShui: "Nhà ở thanh tịnh, hài hòa với cảnh quan thiên nhiên xung quanh." },
  { number: 63, name: "Thủy Hỏa Ký Tế", upper: "Khảm (Nước)", lower: "Ly (Lửa)", symbol: "☵☲", meaning: "Mọi việc đã hoàn thành mỹ mãn. Cân bằng tuyệt đối, cần cẩn trọng giữ gìn thành quả.", fengShui: "Bếp và bồn rửa giữ khoảng cách an toàn, Thủy Hỏa hài hòa không xung khắc." },
  { number: 64, name: "Hỏa Thủy Vị Tế", upper: "Ly (Lửa)", lower: "Khảm (Nước)", symbol: "☲☵", meaning: "Chưa xong, bắt đầu một chu kỳ mới. Luôn giữ tinh thần cầu tiến, chuẩn bị kỹ lưỡng.", fengShui: "Cần thường xuyên thanh lọc không khí, dọn dẹp vật dụng dư thừa để đón khí mới." }
];

export const SAT_KHI_LIST: SatKhiItem[] = [
  {
    name: "Thương Sát (Đường đâm thẳng vào nhà)",
    danger: "Dòng xe cộ lao thẳng vào cửa chính tạo luồng sát khí dữ dội, dễ gây tai nạn, bệnh tật, tán tài.",
    solution: "Xây tường bình phong chắn khí trước cửa, treo Gương Bát Quái Lồi ở cửa chính, trồng hàng rào cây xanh hoặc dựng hòn non bộ chấn sát."
  },
  {
    name: "Thiên Trảm Sát (Khe hẹp giữa 2 tòa nhà cao)",
    danger: "Khe gió hẹp tạo luồng gió xoáy xé toạc sinh khí, ảnh hưởng nghiêm trọng đến sức khỏe và sự nghiệp.",
    solution: "Treo Gương Bát Quái Lồi hoặc đặt cặp Kỳ Lân bằng đồng/đá quay đầu ra phía khe hẹp; trồng cây cao rậm cản gió."
  },
  {
    name: "Bạch Hổ Sát (Bên phải nhà có công trình xây dựng lớn)",
    danger: "Bạch Hổ khởi động lấn át Thanh Long, chủ về phụ nữ trong nhà bất an, dễ xảy ra thị phi tai ách.",
    solution: "Kích hoạt bên trái (Thanh Long) bằng cách treo chuông gió kim loại, đặt rồng xanh hoặc đèn chiếu sáng rực rỡ."
  },
  {
    name: "Xà Ngang Đè Đầu (Áp Đỉnh Sát)",
    danger: "Xà nhà bằng bê tông đè lên giường ngủ, bàn làm việc hoặc bếp gây ức chế thần kinh, đau đầu, suy nhược.",
    solution: "Đóng trần thạch cao che kín xà ngang; nếu không thể, di dời vị trí giường/bàn ra khỏi phạm vi dưới xà."
  },
  {
    name: "Cửa Đối Cửa (Đấu Khẩu Sát)",
    danger: "Hai cánh cửa phòng hoặc cửa chính hai nhà đối diện nhau dễ sinh cãi vã, bất hòa, gia đạo xào xáo.",
    solution: "Treo rèm vải hoặc chuông gió gỗ ở cửa; đặt chậu cây cảnh xanh tươi phân tán luồng khí trực xung."
  }
];

export const BEP_MAPPING = [
  { cung: "Càn (Tây Tứ Mệnh)", toa: "Tọa Đông, Đông Nam, Bắc, Nam", huong: "Hướng Tây, Tây Bắc, Tây Nam, Đông Bắc" },
  { cung: "Khảm (Đông Tứ Mệnh)", toa: "Tọa Tây, Tây Bắc, Tây Nam, Đông Bắc", huong: "Hướng Đông, Đông Nam, Nam, Bắc" },
  { cung: "Cấn (Tây Tứ Mệnh)", toa: "Tọa Đông, Đông Nam, Bắc, Nam", huong: "Hướng Tây Nam, Tây Bắc, Tây, Đông Bắc" },
  { cung: "Chấn (Đông Tứ Mệnh)", toa: "Tọa Tây, Tây Bắc, Tây Nam, Đông Bắc", huong: "Hướng Nam, Bắc, Đông Nam, Đông" },
  { cung: "Tốn (Đông Tứ Mệnh)", toa: "Tọa Tây, Tây Bắc, Tây Nam, Đông Bắc", huong: "Hướng Bắc, Nam, Đông, Đông Nam" },
  { cung: "Ly (Đông Tứ Mệnh)", toa: "Tọa Tây, Tây Bắc, Tây Nam, Đông Bắc", huong: "Hướng Đông, Đông Nam, Bắc, Nam" },
  { cung: "Khôn (Tây Tứ Mệnh)", toa: "Tọa Đông, Đông Nam, Bắc, Nam", huong: "Hướng Đông Bắc, Tây, Tây Bắc, Tây Nam" },
  { cung: "Đoài (Tây Tứ Mệnh)", toa: "Tọa Đông, Đông Nam, Bắc, Nam", huong: "Hướng Tây Bắc, Tây Nam, Đông Bắc, Tây" }
];
