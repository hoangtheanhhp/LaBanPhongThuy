import React, { useState } from 'react';
import { LUBAN_RULERS, LuBanRuler as LuBanRulerType } from '../data/fengshui';
import { Ruler, Info } from 'lucide-react';

export const LuBanRuler: React.FC = () => {
  const [selectedType, setSelectedType] = useState<string>('522');
  const [measurement, setMeasurement] = useState<number>(81);

  const currentRuler: LuBanRulerType =
    LUBAN_RULERS.find((r) => r.type === selectedType) || LUBAN_RULERS[0];

  // Tính cung trên thước
  const unit = currentRuler.unitLength;
  const sectors = currentRuler.sectors;
  const numSectors = sectors.length;

  let remainder = measurement % unit;
  if (remainder < 0) remainder += unit;

  const sectorIndex = Math.min(
    Math.floor((remainder / unit) * numSectors),
    numSectors - 1
  );
  const activeSector = sectors[sectorIndex];

  return (
    <div className="bg-bg-card border border-wood-border/40 rounded-xl p-4 sm:p-5 shadow-md">
      <div className="flex items-center gap-2 text-wood-accent font-bold text-base mb-2">
        <Ruler className="w-5 h-5" />
        <h2>Thước Lỗ Ban Chuẩn Phong Thuỷ</h2>
      </div>
      <p className="text-xs text-stone-400 mb-4 leading-relaxed">
        Thước Lỗ Ban cổ truyền chia khoảng cách thành các cung tốt xấu. Kích thước lọt vào cung Đỏ mang lại cát lợi tài lộc, cung Đen dẫn tới tai ương hao tán.
      </p>

      {/* Ruler Selector Tabs */}
      <div className="grid grid-cols-3 gap-2 mb-3">
        {LUBAN_RULERS.map((r) => {
          const isActive = selectedType === r.type;
          return (
            <button
              key={r.type}
              onClick={() => setSelectedType(r.type)}
              className={`p-2.5 rounded-lg border text-center transition-all ${
                isActive
                  ? 'bg-bg-elevated border-wood-accent text-wood-accent shadow-sm'
                  : 'bg-bg-input border-wood-border/60 text-stone-400 hover:text-stone-300'
              }`}
            >
              <div className="text-xs sm:text-sm font-bold">{r.unitLength} cm</div>
              <div className="text-[10px] mt-0.5 truncate">{r.name.replace('Thước Lỗ Ban ', '')}</div>
            </button>
          );
        })}
      </div>

      <div className="flex items-start gap-1.5 text-[11px] text-wood-accent/90 italic mb-4 bg-wood-accent/10 border border-wood-accent/20 rounded-md p-2">
        <Info className="w-4 h-4 shrink-0 mt-0.5" />
        <span>{currentRuler.usage}</span>
      </div>

      {/* Metric Input & Slider */}
      <div className="bg-bg-input border border-wood-border rounded-xl p-4">
        <div className="flex items-center justify-between mb-2">
          <label className="text-xs font-semibold text-stone-300">
            Kích thước đo được:
          </label>
          <div className="flex items-baseline gap-1">
            <input
              type="number"
              value={measurement}
              onChange={(e) => setMeasurement(parseFloat(e.target.value) || 0)}
              min={0}
              max={500}
              step={0.5}
              className="w-20 bg-transparent text-right font-extrabold text-2xl text-wood-accent border-b border-wood-accent outline-none"
            />
            <span className="text-xs font-medium text-stone-400">cm</span>
          </div>
        </div>

        <input
          type="range"
          min={0}
          max={300}
          step={0.5}
          value={measurement}
          onChange={(e) => setMeasurement(parseFloat(e.target.value) || 0)}
          className="w-full h-2 bg-stone-800 rounded-lg appearance-none cursor-pointer accent-wood-accent my-3"
        />

        {/* Quick suggestions */}
        <div className="flex gap-1.5 overflow-x-auto no-scrollbar py-1 text-[11px]">
          <span className="text-stone-500 self-center">Gợi ý kích thước cửa:</span>
          {[69, 81, 106, 126, 153, 176, 197, 212].map((sug) => (
            <button
              key={sug}
              onClick={() => setMeasurement(sug)}
              className="bg-bg-card hover:bg-bg-elevated border border-wood-border/40 text-stone-300 px-2 py-0.5 rounded text-[10px]"
            >
              {sug}cm
            </button>
          ))}
        </div>

        {/* Result Indicator Strip */}
        <div
          className={`mt-4 py-3 px-4 rounded-lg flex items-center justify-center font-bold text-sm tracking-wide shadow-md transition-colors ${
            activeSector.isGood
              ? 'bg-gradient-to-r from-emerald-900 to-emerald-700 text-white border border-emerald-400'
              : 'bg-gradient-to-r from-rose-950 to-rose-800 text-white border border-rose-500'
          }`}
        >
          {activeSector.isGood ? (
            <span>✦ CUNG {activeSector.name.toUpperCase()} (CÁT - TỐT LÀNH) ✦</span>
          ) : (
            <span>✖ CUNG {activeSector.name.toUpperCase()} (HUNG - NÊN TRÁNH) ✖</span>
          )}
        </div>

        {/* Explanation */}
        <div className="mt-3 p-3 bg-bg-card/70 border-l-2 border-wood-accent rounded-r-md text-xs text-stone-300">
          <strong className="text-wood-accent">Ý nghĩa cung {activeSector.name}: </strong>
          {activeSector.desc}
        </div>
      </div>
    </div>
  );
};
