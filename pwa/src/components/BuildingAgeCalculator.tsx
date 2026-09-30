import React, { useState } from 'react';

// Lunar calculator logic (simplified port from Flutter)
const canList = ['Giáp', 'Ất', 'Bính', 'Đinh', 'Mậu', 'Kỷ', 'Canh', 'Tân', 'Nhâm', 'Quý'];
const chiList = ['Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ', 'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'];

function getCanChiYear(year: number): string {
  const canIdx = (year + 6) % 10;
  const chiIdx = (year + 8) % 12;
  return `${canList[canIdx]} ${chiList[chiIdx]}`;
}

const tamTaiMap: Record<number, number[]> = {
  0: [2, 3, 4], 4: [2, 3, 4], 8: [2, 3, 4],
  2: [8, 9, 10], 6: [8, 9, 10], 10: [8, 9, 10],
  5: [11, 0, 1], 9: [11, 0, 1], 1: [11, 0, 1],
  11: [5, 6, 7], 3: [5, 6, 7], 7: [5, 6, 7],
};

interface BuildingResult {
  lunarAge: number;
  canChiBirth: string;
  canChiBuild: string;
  isTamTai: boolean;
  tamTaiDesc: string;
  isKimLau: boolean;
  kimLauType: string;
  kimLauDesc: string;
  isHoangOcGood: boolean;
  hoangOcPalace: string;
  hoangOcDesc: string;
  canBuild: boolean;
  conclusion: string;
  borrowYears: number[];
}

function calculateBuildingAge(birthYear: number, buildYear: number): BuildingResult {
  const lunarAge = buildYear - birthYear + 1;
  const birthChi = (birthYear + 8) % 12;
  const buildChi = (buildYear + 8) % 12;
  const canChiBirth = getCanChiYear(birthYear);
  const canChiBuild = getCanChiYear(buildYear);

  // Tam Tai
  const isTamTai = tamTaiMap[birthChi]?.includes(buildChi) ?? false;
  const tamTaiDesc = isTamTai
    ? `Phạm Tam Tai năm ${canChiBuild}. Dễ gặp rủi ro, bất trắc sức khỏe.`
    : 'Không phạm Tam Tai. Năm thuận hòa với tuổi gia chủ.';

  // Kim Lâu
  const klRem = lunarAge % 9;
  const isKimLau = [1, 3, 6, 8].includes(klRem);
  let kimLauType = 'Không phạm';
  let kimLauDesc = 'Không phạm Kim Lâu. Rất cát lợi.';
  if (klRem === 1) { kimLauType = 'Kim Lâu Thân'; kimLauDesc = 'Phạm Kim Lâu Thân: Hại bản thân gia chủ.'; }
  else if (klRem === 3) { kimLauType = 'Kim Lâu Thê'; kimLauDesc = 'Phạm Kim Lâu Thê: Hại người vợ.'; }
  else if (klRem === 6) { kimLauType = 'Kim Lâu Tử'; kimLauDesc = 'Phạm Kim Lâu Tử: Trắc trở đường con cái.'; }
  else if (klRem === 8) { kimLauType = 'Kim Lâu Súc'; kimLauDesc = 'Phạm Kim Lâu Lục Súc: Hao tổn kinh tế.'; }

  // Hoang Ốc
  const tens = Math.floor(lunarAge / 10);
  const units = lunarAge % 10;
  const hoangOcIndex = ((tens - 1 + units) % 6 + 6) % 6 + 1;

  const hoangOcData: Record<number, { palace: string; good: boolean; desc: string }> = {
    1: { palace: 'Nhất Cát', good: true, desc: 'Vạn sự hanh thông, phúc lộc dồi dào.' },
    2: { palace: 'Nhì Nghi', good: true, desc: 'Giàu sang hưng vượng, gia nghiệp phát triển.' },
    3: { palace: 'Tam Địa Sát', good: false, desc: 'Phạm Địa Sát: Ốm đau bệnh tật, tổn thất nhân đinh.' },
    4: { palace: 'Tứ Tấn Tài', good: true, desc: 'Tài lộc tấn tới, phước đức ngập tràn.' },
    5: { palace: 'Ngũ Thọ Tử', good: false, desc: 'Phạm Thọ Tử: Ly tán, mâu thuẫn bất hòa.' },
    6: { palace: 'Lục Hoang Ốc', good: false, desc: 'Phạm Hoang Ốc: Khó hoàn thành, nghèo khó.' },
  };

  const ho = hoangOcData[hoangOcIndex] || hoangOcData[6];
  const canBuild = !isTamTai && !isKimLau && ho.good;

  const conclusion = canBuild
    ? `Năm ${buildYear} (${canChiBuild}) là NĂM ĐẠI CÁT! Tuổi ${lunarAge} không phạm Tam Tai, Kim Lâu và cung Hoang Ốc tốt lành.`
    : `Năm ${buildYear} (${canChiBuild}) ${isKimLau ? `phạm ${kimLauType}` : isTamTai ? 'phạm Tam Tai' : `phạm Hoang Ốc (${ho.palace})`}. Nên MƯỢN TUỔI người hợp năm.`;

  // Gợi ý mượn tuổi
  const candidates = Array.from({ length: 60 }, (_, i) => 1950 + i);
  const borrowYears: number[] = [];
  for (const yr of candidates) {
    const age = buildYear - yr + 1;
    if (age < 18 || age > 80) continue;
    const chi = (yr + 8) % 12;
    const tt = tamTaiMap[chi]?.includes(buildChi) ?? false;
    const kl = age % 9;
    const klBad = [1, 3, 6, 8].includes(kl);
    const t = Math.floor(age / 10);
    const u = age % 10;
    const hoIdx = ((t - 1 + u) % 6 + 6) % 6 + 1;
    const hoGood = [1, 2, 4].includes(hoIdx);
    if (!tt && !klBad && hoGood) borrowYears.push(yr);
  }

  return {
    lunarAge, canChiBirth, canChiBuild,
    isTamTai, tamTaiDesc, isKimLau, kimLauType, kimLauDesc,
    isHoangOcGood: ho.good, hoangOcPalace: ho.palace, hoangOcDesc: ho.desc,
    canBuild, conclusion, borrowYears: borrowYears.slice(0, 12),
  };
}

function ResultBadge({ isHung }: { isHung: boolean }) {
  return (
    <span className={`text-[9px] font-bold px-1.5 py-0.5 rounded ${isHung ? 'bg-red-500/15 text-red-400' : 'bg-green-500/15 text-green-400'}`}>
      {isHung ? 'HUNG' : 'CÁT'}
    </span>
  );
}

function ResultRow({ title, isHung, description }: { title: string; isHung: boolean; description: string }) {
  return (
    <div className={`p-3 rounded-lg border ${isHung ? 'border-red-500/30' : 'border-green-500/30'} bg-bg-card`}>
      <div className="flex items-center justify-between mb-1">
        <span className="text-ivory text-xs font-bold">{title}</span>
        <ResultBadge isHung={isHung} />
      </div>
      <p className="text-stone-400 text-[11px] leading-relaxed">{description}</p>
    </div>
  );
}

export const BuildingAgeCalculator: React.FC = () => {
  const currentYear = new Date().getFullYear();
  const [birthYear, setBirthYear] = useState(1990);
  const [buildYear, setBuildYear] = useState(currentYear);
  const [result, setResult] = useState<BuildingResult | null>(null);

  const handleCalculate = () => {
    setResult(calculateBuildingAge(birthYear, buildYear));
  };

  return (
    <div className="space-y-4">
      <div className="bg-bg-card rounded-xl border border-wood-border/30 p-4">
        <h2 className="text-wood-accent text-base font-bold flex items-center gap-2 mb-1">
          🏡 Xem Tuổi Làm Nhà
        </h2>
        <p className="text-stone-400 text-xs mb-4">
          Tra cứu Tam Tai · Kim Lâu · Hoang Ốc cho năm xây nhà
        </p>

        <div className="grid grid-cols-2 gap-3 mb-4">
          <div>
            <label className="text-stone-400 text-[11px] block mb-1">Năm sinh (Dương lịch)</label>
            <select
              value={birthYear}
              onChange={(e) => setBirthYear(Number(e.target.value))}
              className="w-full bg-bg-elevated border border-wood-border rounded-lg px-3 py-2 text-sm text-ivory focus:border-wood-accent focus:outline-none"
            >
              {Array.from({ length: 80 }, (_, i) => 1945 + i).map(y => (
                <option key={y} value={y}>{y}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="text-stone-400 text-[11px] block mb-1">Năm xây nhà</label>
            <select
              value={buildYear}
              onChange={(e) => setBuildYear(Number(e.target.value))}
              className="w-full bg-bg-elevated border border-wood-border rounded-lg px-3 py-2 text-sm text-ivory focus:border-wood-accent focus:outline-none"
            >
              {Array.from({ length: 30 }, (_, i) => 2024 + i).map(y => (
                <option key={y} value={y}>{y}</option>
              ))}
            </select>
          </div>
        </div>

        <button
          onClick={handleCalculate}
          className="w-full bg-wood-accent text-bg-dark font-bold py-2.5 rounded-lg hover:opacity-90 transition-opacity"
        >
          🔍 Tra Cứu
        </button>
      </div>

      {result && (
        <div className="space-y-3">
          {/* Tổng kết */}
          <div className={`p-3.5 rounded-xl border ${result.canBuild ? 'bg-green-950/40 border-green-500/40' : 'bg-red-950/40 border-red-500/40'}`}>
            <div className="flex items-start gap-2">
              <span className="text-lg">{result.canBuild ? '✅' : '⚠️'}</span>
              <p className={`text-xs font-semibold leading-relaxed ${result.canBuild ? 'text-green-300' : 'text-red-300'}`}>
                {result.conclusion}
              </p>
            </div>
          </div>

          {/* Thông tin tuổi */}
          <div className="bg-bg-card rounded-lg border border-wood-border/30 p-3">
            <p className="text-wood-accent text-sm font-bold">
              Tuổi {result.canChiBirth} · Tuổi mụ: {result.lunarAge}
            </p>
            <p className="text-stone-400 text-xs">Năm xây: {result.canChiBuild}</p>
          </div>

          {/* Chi tiết */}
          <ResultRow title="Tam Tai" isHung={result.isTamTai} description={result.tamTaiDesc} />
          <ResultRow
            title={`Kim Lâu ${result.isKimLau ? `(${result.kimLauType})` : ''}`}
            isHung={result.isKimLau}
            description={result.kimLauDesc}
          />
          <ResultRow
            title={`Hoang Ốc: ${result.hoangOcPalace}`}
            isHung={!result.isHoangOcGood}
            description={result.hoangOcDesc}
          />

          {/* Gợi ý mượn tuổi */}
          {!result.canBuild && result.borrowYears.length > 0 && (
            <div className="bg-blue-950/30 rounded-lg border border-blue-500/30 p-3">
              <p className="text-blue-400 text-[11px] font-bold mb-2 flex items-center gap-1">
                👥 GỢI Ý MƯỢN TUỔI
              </p>
              <div className="flex flex-wrap gap-1.5">
                {result.borrowYears.map(yr => (
                  <span key={yr} className="text-[11px] bg-blue-500/10 border border-blue-500/30 rounded px-2 py-1 text-stone-300">
                    {yr} ({getCanChiYear(yr)})
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
};
