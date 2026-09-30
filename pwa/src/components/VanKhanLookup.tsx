import React, { useState } from 'react';

interface VanKhan {
  id: string;
  title: string;
  category: string;
  occasion: string;
  content: string;
}

const vanKhanData: VanKhan[] = [
  {
    id: 'mung1',
    title: 'Văn Khấn Ngày Mùng 1 & Ngày Rằm',
    category: 'Hàng Tháng',
    occasion: 'Mùng 1 & 15 Âm lịch',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng, ngài Bản xứ Thổ Địa, ngài Bản gia Táo Quân cùng chư vị Tôn Thần.
Con kính lạy Tổ Tiên, Hiển Khảo, Hiển Tỷ, chư vị Hương Linh.

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay là ngày ..... tháng ..... năm ..... (Âm lịch)
Tín chủ con thành tâm sửa biện hương hoa lễ vật, kim ngân trà quả, bày lên trước án, kính cẩn dâng lên trước toàn thể các ngài.

Cúi xin chư vị Tôn Thần, Tiền Hậu lưỡng vị gia tiên, chứng giám lòng thành, thụ hưởng lễ vật, phù hộ độ trì cho gia đình con:
- An khang thịnh vượng
- Mọi việc hanh thông
- Gia đạo bình an
- Con cháu hiếu thuận

Tín chủ con lễ bạc tâm thành, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'dongthoi',
    title: 'Văn Khấn Lễ Động Thổ',
    category: 'Xây Dựng',
    occasion: 'Khởi công xây nhà',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Kim Niên Đương Cai Thái Tuế Chí Đức Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng Chư vị Đại Vương.
Con kính lạy các ngài Ngũ Phương, Ngũ Thổ, Long Mạch, Tôn Thần, các ngài Tiền Chu Tước, Hậu Huyền Vũ, Tả Thanh Long, Hữu Bạch Hổ cùng liệt vị Tôn Thần cai quản khu vực này.

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay là ngày ..... tháng ..... năm ..... (Âm lịch)

Tín chủ con khởi tạo (sửa chữa) ngôi gia cư tại (địa chỉ mảnh đất).

Nay chọn được ngày lành tháng tốt, thiết lập hương án, sắm sanh lễ vật, kính cẩn dâng lên trước mặt chư vị Tôn Thần, cúi xin chứng giám:

- Cho phép được khởi công xây dựng
- Phù hộ cho công trình được thuận lợi hanh thông
- Không gặp trở ngại tai ương
- Thợ thầy an toàn, vạn sự kiết tường

Chúng con lễ bạc tâm thành, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'nhaptrac',
    title: 'Văn Khấn Lễ Nhập Trạch',
    category: 'Xây Dựng',
    occasion: 'Dọn vào nhà mới',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng, ngài Bản xứ Thổ Địa, ngài Bản gia Táo Quân cùng chư vị Tôn Thần.

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay là ngày ..... tháng ..... năm ..... (Âm lịch)
Là ngày tốt lành, tín chủ con chuyển đến cư ngụ tại đây.

Thành tâm sắm sanh lễ vật, hương hoa trà quả, kim ngân phẩm oản, kính cẩn dâng lên trước án, cúi xin:

- Chư vị Tôn Thần cho phép được nhập trạch
- Phù hộ gia đình an cư lạc nghiệp
- Vạn sự tốt lành, mọi người khỏe mạnh
- Làm ăn phát đạt, gia đạo bình yên

Chúng con lễ bạc tâm thành, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'khahtruong',
    title: 'Văn Khấn Khai Trương',
    category: 'Kinh Doanh',
    occasion: 'Khai trương cửa hàng, công ty',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng, ngài Bản xứ Thổ Địa, ngài Bản gia Táo Quân, ngài Thần Tài Thổ Địa cùng chư vị Tôn Thần.

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay là ngày ..... tháng ..... năm ..... (Âm lịch)
Tín chủ con khai trương (tên cửa hàng/công ty) tại (địa chỉ).

Thành tâm sắm sanh lễ vật, kim ngân hương hoa, dâng lên trước án, kính cẩn cúi xin:

- Chư vị Tôn Thần chứng giám lòng thành
- Phù hộ cho việc kinh doanh thuận lợi
- Buôn may bán đắt, tài lộc dồi dào
- Khách hàng đông đúc, sự nghiệp hanh thông
- Phúc lộc thọ toàn, vạn sự kiết tường

Chúng con lễ bạc tâm thành, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'cuoihoi',
    title: 'Văn Khấn Lễ Cưới Hỏi',
    category: 'Hôn Nhân',
    occasion: 'Lễ vu quy / đón dâu',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng, ngài Bản xứ Thổ Địa cùng chư vị Tôn Thần.
Con kính lạy Tiên Tổ dòng họ ..................

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay là ngày ..... tháng ..... năm ..... (Âm lịch)

Nay nhân ngày lành tháng tốt, gia đình chúng con có con (trai/gái) tên là .................. thành hôn với .................., con (ông/bà) ..................

Thành tâm sửa biện hương hoa lễ vật, kính dâng lên trước bàn thờ Tổ Tiên, cúi xin:

- Tiên Tổ, Nội Ngoại chứng giám
- Phù hộ cho đôi trẻ thuận hòa, hạnh phúc
- Sớm sinh quý tử, nối dõi tông đường
- Gia đình hưng thịnh, con cháu sum vầy

Chúng con lễ bạc tâm thành, cúi xin được phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'giaothua',
    title: 'Văn Khấn Đêm Giao Thừa',
    category: 'Tết Nguyên Đán',
    occasion: 'Ngoài trời đêm 30 Tết',
    content: `Nam mô A Di Đà Phật! (3 lần)

Kính lạy:
- Đức Đương Lai Hạ Sanh Di Lặc Tôn Phật
- Hoàng Thiên Hậu Thổ, chư vị Tôn Thần
- Ngài Cựu Niên Đương Cai Thái Tuế Chí Đức Tôn Thần
- Ngài Tân Niên Đương Cai Thái Tuế Chí Đức Tôn Thần
- Ngài Bản cảnh Thành Hoàng Chư vị Đại Vương
- Ngài Bản xứ Thần linh Thổ Địa
- Ngài Ngũ Phương Long Mạch, Tài thần
- Các vị Tiền Hậu Hương Linh

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Giờ phút thiêng liêng Giao Thừa, năm cũ qua năm mới đến.

Nay tín chủ con thành tâm sắm sanh lễ vật, hương hoa trà quả, phẩm oản kim ngân, kính cẩn dâng lên trước án, thành tâm cầu nguyện:

- Năm mới vạn sự kiết tường, bách sự hanh thông
- Gia đạo bình an, sức khỏe dồi dào
- Tài lộc phát triển, công danh sáng rỡ
- Con cháu hiếu thuận, phúc lộc đầy nhà

Cúi xin chư vị Tôn Thần chứng giám, phù hộ cho gia đình chúng con.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'xongdat',
    title: 'Văn Khấn Xông Đất Đầu Năm',
    category: 'Tết Nguyên Đán',
    occasion: 'Mùng 1 Tết',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con lạy chín phương Trời, mười phương Chư Phật, Chư Phật mười phương.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Đương Niên Thái Tuế Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng, ngài Bản xứ Thổ Địa, ngài Bản gia Táo Quân cùng chư vị Tôn Thần.
Con kính lạy chư vị Tổ Tiên nội ngoại họ ..................

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay ngày Mùng Một tháng Giêng năm ......

Đầu năm mới, tín chủ con thành tâm dâng lễ vật, cầu xin:

- Chư vị Tôn Thần phù hộ độ trì
- Năm mới thái bình, phú quý cát tường
- Gia đạo hưng long, con cháu sum vầy
- Tài lộc dồi dào, sức khỏe bền vững

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'ongtao',
    title: 'Văn Khấn Tiễn Ông Táo',
    category: 'Tết Nguyên Đán',
    occasion: '23 tháng Chạp',
    content: `Nam mô A Di Đà Phật! (3 lần)

Kính lạy ngài Đông Trù Tư Mệnh Táo Phủ Thần Quân.

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay, ngày 23 tháng Chạp, tín chủ con thành tâm sắm sanh lễ vật, hương hoa trà quả, thắp nén tâm hương, cung kính tiễn ngài Táo Quân về chầu Ngọc Hoàng Thượng Đế.

Cầu xin ngài Táo Quân:
- Tâu bớt điều dữ, thêm điều lành cho gia đình
- Phù hộ gia đạo bình an, mọi sự tốt lành
- Năm mới tài lộc hanh thông
- Con cháu hiếu thuận, khỏe mạnh bình an

Cúi xin ngài chứng giám lòng thành, phù hộ độ trì.

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'thanminh',
    title: 'Văn Khấn Tảo Mộ (Thanh Minh)',
    category: 'Lễ Hội',
    occasion: 'Tiết Thanh Minh',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con kính lạy Đức Phật A Di Đà.
Con kính lạy chư vị Tôn Thần quản cai nơi nghĩa trang (nghĩa địa) này.
Con kính lạy vong linh (Ông/Bà/Cha/Mẹ) .................. Hương linh.

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay là ngày ..... tháng ..... năm ..... (Âm lịch), tiết Thanh Minh.

Con cháu chúng con nhân tiết Thanh Minh, đến trước phần mộ (Ông/Bà/Cha/Mẹ), thành tâm kính cẩn:

- Dâng hương hoa lễ vật
- Sửa sang phần mộ cho sạch sẽ
- Tưởng nhớ công ơn sinh thành dưỡng dục

Cúi xin vong linh chứng giám lòng thành, phù hộ cho con cháu:
- Mạnh khỏe, bình an, gặp nhiều may mắn
- Gia đạo hưng thịnh, mọi việc hanh thông

Nam mô A Di Đà Phật! (3 lần)`
  },
  {
    id: 'vulan',
    title: 'Văn Khấn Rằm Tháng 7 (Vu Lan)',
    category: 'Lễ Hội',
    occasion: 'Rằm tháng 7 Vu Lan',
    content: `Nam mô A Di Đà Phật! (3 lần)

Con kính lạy Đức Phật A Di Đà.
Con kính lạy Bồ Tát Đại Hiếu Mục Kiền Liên.
Con kính lạy Hoàng Thiên Hậu Thổ, chư vị Tôn Thần.
Con kính lạy ngài Bản cảnh Thành Hoàng, ngài Bản xứ Thổ Địa cùng chư vị Tôn Thần.
Con kính lạy Tổ Tiên nội ngoại họ ..................

Tín chủ (chúng) con là: ..................
Ngụ tại: ..................

Hôm nay ngày Rằm tháng 7, đại lễ Vu Lan Báo Hiếu.

Tín chủ con thành tâm sửa biện hương hoa lễ vật, dâng lên trước án:

- Tưởng nhớ công đức Tổ Tiên, Cha Mẹ
- Cầu siêu cho các vong linh sớm được siêu thoát
- Cầu nguyện cho cha mẹ còn sống sức khỏe dồi dào

Cúi xin chư vị chứng giám lòng thành, phù hộ cho gia đình:
- Người sống an lành, người khuất siêu thoát
- Gia đạo hưng long, con cháu thảo hiền

Nam mô A Di Đà Phật! (3 lần)`
  },
];

const categories = ['Tất cả', ...Array.from(new Set(vanKhanData.map(v => v.category)))];

export const VanKhanLookup: React.FC = () => {
  const [selectedCategory, setSelectedCategory] = useState('Tất cả');
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');

  const filteredData = vanKhanData.filter(vk => {
    const matchCategory = selectedCategory === 'Tất cả' || vk.category === selectedCategory;
    const matchSearch = !searchQuery ||
      vk.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      vk.occasion.toLowerCase().includes(searchQuery.toLowerCase());
    return matchCategory && matchSearch;
  });

  return (
    <div className="space-y-4">
      <div className="bg-bg-card rounded-xl border border-wood-border/30 p-4">
        <h2 className="text-wood-accent text-base font-bold flex items-center gap-2 mb-1">
          🙏 Văn Khấn Cổ Truyền
        </h2>
        <p className="text-stone-400 text-xs mb-3">
          Tuyển tập bài văn khấn truyền thống Việt Nam cho các dịp lễ
        </p>

        {/* Tìm kiếm */}
        <input
          type="text"
          placeholder="Tìm bài văn khấn..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full bg-bg-elevated border border-wood-border rounded-lg px-3 py-2 text-sm text-ivory placeholder-stone-500 focus:border-wood-accent focus:outline-none mb-3"
        />

        {/* Danh mục */}
        <div className="flex gap-2 overflow-x-auto no-scrollbar pb-1">
          {categories.map(cat => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-3 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                selectedCategory === cat
                  ? 'bg-bg-elevated border border-wood-accent text-wood-accent'
                  : 'text-stone-300 border border-transparent hover:text-white'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {/* Danh sách bài Văn Khấn */}
      <div className="space-y-2">
        {filteredData.length === 0 && (
          <div className="text-center text-stone-500 text-sm py-8">
            Không tìm thấy bài văn khấn phù hợp.
          </div>
        )}

        {filteredData.map(vk => {
          const isExpanded = expandedId === vk.id;
          return (
            <div key={vk.id} className="bg-bg-card rounded-xl border border-wood-border/30 overflow-hidden">
              <button
                onClick={() => setExpandedId(isExpanded ? null : vk.id)}
                className="w-full px-4 py-3 text-left flex items-center justify-between"
              >
                <div>
                  <p className="text-ivory text-sm font-bold">{vk.title}</p>
                  <p className="text-stone-400 text-[11px] mt-0.5">
                    {vk.category} · {vk.occasion}
                  </p>
                </div>
                <span className={`text-stone-400 transition-transform ${isExpanded ? 'rotate-180' : ''}`}>
                  ▾
                </span>
              </button>

              {isExpanded && (
                <div className="border-t border-wood-border/20 px-4 py-3 bg-bg-elevated/50">
                  <pre className="text-ivory text-xs leading-relaxed whitespace-pre-wrap font-sans">
                    {vk.content}
                  </pre>
                  <button
                    onClick={() => {
                      navigator.clipboard.writeText(vk.content);
                    }}
                    className="mt-3 text-[11px] bg-wood-accent/15 border border-wood-accent/40 text-wood-accent rounded-lg px-3 py-1.5 hover:bg-wood-accent/25 transition-colors"
                  >
                    📋 Sao chép bài khấn
                  </button>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};
