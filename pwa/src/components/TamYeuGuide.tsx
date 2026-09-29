import React from 'react';
import { BEP_MAPPING } from '../data/fengshui';
import { Home, Flame, Bed, DoorOpen } from 'lucide-react';

export const TamYeuGuide: React.FC = () => {
  return (
    <div className="space-y-4">
      <div className="bg-bg-card border border-wood-border/40 rounded-xl p-4 sm:p-5 shadow-md">
        <div className="flex items-center gap-2 text-wood-accent font-bold text-base mb-2">
          <Home className="w-5 h-5" />
          <h2>Dương Trạch Tam Yếu (Môn - Chủ - Táo)</h2>
        </div>
        <p className="text-xs text-stone-300 leading-relaxed mb-4">
          Sách <em>Dương Trạch Tam Yếu</em> của danh sư Triệu Cửu Phong khẳng định: Cửa chính (Môn), Phòng ngủ gia chủ (Chủ) và Bếp nấu (Táo) là 3 vị trí then chốt chi phối 80% cát hung của ngôi nhà.
        </p>

        {/* 3 Pillars */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-3 mb-5">
          <div className="bg-bg-input border border-wood-border/40 rounded-lg p-3">
            <div className="flex items-center gap-2 text-wood-accent font-bold text-xs mb-1.5">
              <DoorOpen className="w-4 h-4 text-wood-accent" />
              <span>1. Môn (Cửa Chính)</span>
            </div>
            <p className="text-[11.5px] text-stone-400 leading-normal">
              Là khí khẩu đón nhận sinh khí vào toàn bộ căn nhà. Cửa chính phải mở về phương hướng Cát của gia chủ (Sinh Khí, Thiên Y, Diên Niên, Phục Vị), tránh đối diện cửa hậu hoặc gương soi.
            </p>
          </div>

          <div className="bg-bg-input border border-wood-border/40 rounded-lg p-3">
            <div className="flex items-center gap-2 text-wood-accent font-bold text-xs mb-1.5">
              <Bed className="w-4 h-4 text-wood-accent" />
              <span>2. Chủ (Phòng Ngủ)</span>
            </div>
            <p className="text-[11.5px] text-stone-400 leading-normal">
              Nơi nuôi dưỡng sinh khí và sức khỏe. Đầu giường cần đặt tại phương Sinh Khí hoặc Thiên Y, có điểm tựa vững chãi, kỵ xà ngang đè đầu hoặc quay chân thẳng ra cửa.
            </p>
          </div>

          <div className="bg-bg-input border border-wood-border/40 rounded-lg p-3">
            <div className="flex items-center gap-2 text-wood-accent font-bold text-xs mb-1.5">
              <Flame className="w-4 h-4 text-wood-accent" />
              <span>3. Táo (Bếp Nấu)</span>
            </div>
            <p className="text-[11.5px] text-stone-400 leading-normal">
              Chủ về tài lộc và tiêu hóa. Nguyên tắc vàng: <strong>"TỌA HUNG HƯỚNG CÁT"</strong> — Đặt bếp nằm trên cung xấu để thiêu đốt hung khí, mặt bếp hướng về cung tốt đón vượng khí.
            </p>
          </div>
        </div>

        {/* Bếp Mapping Table */}
        <div className="border-t border-wood-border/40 pt-4">
          <div className="flex items-center gap-2 text-xs font-bold text-wood-accent uppercase tracking-wider mb-2.5">
            <Flame className="w-4 h-4 text-orange-400" />
            <span>Bảng Tra Cứu Tọa Hung Hướng Cát Bếp Nấu Theo 8 Cung Mạng</span>
          </div>

          <div className="overflow-x-auto rounded-lg border border-wood-border/50">
            <table className="w-full text-left text-xs border-collapse">
              <thead>
                <tr className="bg-bg-elevated text-wood-accent border-b border-wood-border">
                  <th className="p-2.5 font-bold">Cung Mệnh</th>
                  <th className="p-2.5 font-bold text-rose-400">Tọa Bếp (Cung Xấu Nên Đặt)</th>
                  <th className="p-2.5 font-bold text-emerald-400">Hướng Bếp (Miệng Bếp Quay Về)</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-wood-border/30 bg-bg-input">
                {BEP_MAPPING.map((item, idx) => (
                  <tr key={idx} className="hover:bg-bg-elevated/50 transition-colors">
                    <td className="p-2.5 font-bold text-wood-accent whitespace-nowrap">{item.cung}</td>
                    <td className="p-2.5 text-rose-300">{item.toa}</td>
                    <td className="p-2.5 text-emerald-300 font-medium">{item.huong}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};
