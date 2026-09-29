import React, { useState } from 'react';
import { BAGUA_PALACES, BaguaPalace } from '../data/fengshui';
import { Compass, CheckCircle2, AlertTriangle, ArrowRight } from 'lucide-react';

export const CungCalculator: React.FC = () => {
  const [birthYear, setBirthYear] = useState<number>(1990);
  const [gender, setGender] = useState<'male' | 'female'>('male');
  const [result, setResult] = useState<BaguaPalace | null>(() => calculateCung(1990, 'male'));

  function calculateCung(year: number, gen: 'male' | 'female'): BaguaPalace | null {
    let sum = year % 100;
    while (sum >= 10) {
      sum = Math.floor(sum / 10) + (sum % 10);
    }

    let quaiNumber: number;
    if (year < 2000) {
      if (gen === 'male') {
        quaiNumber = (10 - sum) % 9;
        if (quaiNumber === 0) quaiNumber = 9;
      } else {
        quaiNumber = (5 + sum) % 9;
        if (quaiNumber === 0) quaiNumber = 9;
      }
    } else {
      if (gen === 'male') {
        quaiNumber = (9 - sum) % 9;
        if (quaiNumber === 0) quaiNumber = 9;
      } else {
        quaiNumber = (6 + sum) % 9;
        if (quaiNumber === 0) quaiNumber = 9;
      }
    }

    if (quaiNumber === 5) {
      quaiNumber = gen === 'male' ? 2 : 8;
    }

    const mapping: Record<number, string> = {
      1: 'kham',
      2: 'khon',
      3: 'chan',
      4: 'ton',
      6: 'can',
      7: 'doai',
      8: 'can_tho',
      9: 'ly',
    };

    const palaceId = mapping[quaiNumber];
    return BAGUA_PALACES.find((b) => b.id === palaceId) || null;
  }

  const handleCalculate = () => {
    const pal = calculateCung(birthYear, gender);
    setResult(pal);
  };

  return (
    <div className="space-y-4">
      {/* Form Card */}
      <div className="bg-bg-card border border-wood-border/40 rounded-xl p-4 sm:p-5 shadow-md">
        <div className="flex items-center gap-2 text-wood-accent font-bold text-base mb-3">
          <Compass className="w-5 h-5" />
          <h2>Thiết Lập Mệnh Quái (Bát Trạch Minh Cảnh)</h2>
        </div>
        <p className="text-xs text-stone-400 mb-4 leading-relaxed">
          Theo cổ thư <em>Bát Trạch Minh Cảnh</em>, mệnh quái quyết định 4 phương vị sinh tài đón phúc và 4 phương vị hung hại cần kiêng kỵ khi làm nhà.
        </p>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-3">
          <div>
            <label className="block text-xs font-semibold text-stone-300 mb-1.5">
              Năm sinh (Dương lịch):
            </label>
            <input
              type="number"
              value={birthYear}
              onChange={(e) => setBirthYear(parseInt(e.target.value) || 1990)}
              min={1920}
              max={2060}
              className="w-full bg-bg-input border border-wood-border rounded-lg px-3 py-2 text-sm text-ivory focus:border-wood-accent outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-stone-300 mb-1.5">
              Giới tính:
            </label>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => setGender('male')}
                className={`py-2 text-xs font-bold rounded-lg border transition-all ${
                  gender === 'male'
                    ? 'bg-bg-elevated border-wood-accent text-wood-accent'
                    : 'bg-bg-input border-wood-border text-stone-400'
                }`}
              >
                Nam ♂
              </button>
              <button
                type="button"
                onClick={() => setGender('female')}
                className={`py-2 text-xs font-bold rounded-lg border transition-all ${
                  gender === 'female'
                    ? 'bg-bg-elevated border-wood-accent text-wood-accent'
                    : 'bg-bg-input border-wood-border text-stone-400'
                }`}
              >
                Nữ ♀
              </button>
            </div>
          </div>
        </div>

        <button
          onClick={handleCalculate}
          className="w-full mt-2 bg-gradient-to-r from-[#D4AF37] to-wood-accent hover:opacity-95 text-[#141414] font-bold py-2.5 rounded-lg text-sm transition-transform active:scale-[0.99] shadow-md flex items-center justify-center gap-1.5"
        >
          <span>Tra Cứu Hướng Nhà & Mệnh Quái</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      {/* Result Card */}
      {result && (
        <div className="bg-bg-elevated border border-wood-accent rounded-xl p-4 sm:p-5 shadow-lg animate-fadeIn">
          <div className="flex items-start justify-between border-b border-wood-border/40 pb-3 mb-3">
            <div>
              <div className="text-[11px] text-stone-400">
                Gia chủ sinh năm {birthYear} ({gender === 'male' ? 'Nam' : 'Nữ'})
              </div>
              <div className="text-lg sm:text-xl font-extrabold text-wood-accent flex items-center gap-1.5 mt-0.5">
                <span>{result.symbol}</span>
                <span>Cung {result.name} ({result.element})</span>
                <span className="text-xs text-stone-400 font-normal">Quái số {result.number}</span>
              </div>
            </div>
            <span className="bg-wood-accent/20 border border-wood-accent text-wood-accent text-xs font-bold px-2.5 py-1 rounded-md">
              {result.group}
            </span>
          </div>

          <p className="text-xs text-stone-300 leading-relaxed mb-4">
            {result.desc}
          </p>

          {/* 4 Hướng Cát */}
          <div className="mb-4">
            <div className="flex items-center gap-1.5 text-xs font-bold text-emerald-400 mb-2">
              <CheckCircle2 className="w-4 h-4" />
              <span>4 HƯỚNG CÁT (NÊN CHỌN ĐẶT CỬA CHÍNH, BÀN THỜ, PHÒNG NGỦ)</span>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
              {result.goodDirs.map((dir, idx) => (
                <div
                  key={idx}
                  className="bg-bg-input border-l-4 border-emerald-500 rounded p-2.5 text-xs"
                >
                  <div className="flex items-center justify-between font-bold text-emerald-400">
                    <span>{dir.name}</span>
                    <span className="text-[10px] bg-emerald-950/80 px-1.5 py-0.5 rounded border border-emerald-800">
                      CÁT
                    </span>
                  </div>
                  <div className="text-ivory font-semibold mt-0.5">{dir.dir}</div>
                  <div className="text-[11px] text-stone-400 mt-1">{dir.desc}</div>
                </div>
              ))}
            </div>
          </div>

          {/* 4 Hướng Hung */}
          <div>
            <div className="flex items-center gap-1.5 text-xs font-bold text-rose-400 mb-2">
              <AlertTriangle className="w-4 h-4" />
              <span>4 HƯỚNG HUNG (NÊN TRÁNH, HOẶC DÙNG ĐẶT BẾP ĐỂ THIÊU HUNG)</span>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
              {result.badDirs.map((dir, idx) => (
                <div
                  key={idx}
                  className="bg-bg-input border-l-4 border-rose-500 rounded p-2.5 text-xs"
                >
                  <div className="flex items-center justify-between font-bold text-rose-400">
                    <span>{dir.name}</span>
                    <span className="text-[10px] bg-rose-950/80 px-1.5 py-0.5 rounded border border-rose-800">
                      HUNG
                    </span>
                  </div>
                  <div className="text-ivory font-semibold mt-0.5">{dir.dir}</div>
                  <div className="text-[11px] text-stone-400 mt-1">{dir.desc}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Overview 8 Palaces */}
      <div className="bg-bg-card border border-wood-border/40 rounded-xl p-4">
        <h3 className="text-xs font-bold text-wood-accent uppercase tracking-wider mb-2.5">
          Bát Quái Hậu Thiên (8 Cung Phương Vị)
        </h3>
        <div className="grid grid-cols-4 gap-2 text-center">
          {BAGUA_PALACES.map((pal) => (
            <div
              key={pal.id}
              className="bg-bg-input border border-wood-border/30 rounded-lg p-2 hover:border-wood-accent transition-colors"
            >
              <div className="text-xl text-wood-accent">{pal.symbol}</div>
              <div className="text-xs font-bold text-ivory mt-0.5">{pal.name}</div>
              <div className="text-[10px] text-stone-400">{pal.direction}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
