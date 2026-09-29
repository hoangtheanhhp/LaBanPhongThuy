import React, { useState } from 'react';
import { ICHING_HEXAGRAMS, IChingHexagram } from '../data/fengshui';
import { BookOpen, Search, X } from 'lucide-react';

export const IChingLookup: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [selectedHexagram, setSelectedHexagram] = useState<IChingHexagram | null>(null);

  const filtered = ICHING_HEXAGRAMS.filter((q) => {
    const term = searchTerm.toLowerCase().trim();
    if (!term) return true;
    return (
      q.name.toLowerCase().includes(term) ||
      q.upper.toLowerCase().includes(term) ||
      q.lower.toLowerCase().includes(term) ||
      q.meaning.toLowerCase().includes(term) ||
      q.number.toString() === term
    );
  });

  return (
    <div className="bg-bg-card border border-wood-border/40 rounded-xl p-4 sm:p-5 shadow-md">
      <div className="flex items-center gap-2 text-wood-accent font-bold text-base mb-2">
        <BookOpen className="w-5 h-5" />
        <h2>Tra Cứu 64 Quẻ Kinh Dịch</h2>
      </div>
      <p className="text-xs text-stone-400 mb-4 leading-relaxed">
        Kinh Dịch là cội nguồn của Bát Quái và lý khí phong thủy. Mỗi quẻ chứa đựng quy luật biến dịch của trời đất, soi tỏ đường hướng tài vận và hung cát nhà ở.
      </p>

      {/* Search Input */}
      <div className="relative mb-4">
        <Search className="w-4 h-4 text-stone-400 absolute left-3 top-1/2 -translate-y-1/2" />
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="Nhập tên quẻ hoặc số quẻ (VD: Thuần Càn, Thái, 14, 1...)"
          className="w-full bg-bg-input border border-wood-border rounded-full pl-9 pr-4 py-2 text-xs sm:text-sm text-ivory placeholder-stone-500 focus:border-wood-accent outline-none"
        />
        {searchTerm && (
          <button
            onClick={() => setSearchTerm('')}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-stone-400 hover:text-white"
          >
            <X className="w-4 h-4" />
          </button>
        )}
      </div>

      {/* Hexagram Grid */}
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-2.5 max-h-[520px] overflow-y-auto pr-1">
        {filtered.map((hex) => (
          <div
            key={hex.number}
            onClick={() => setSelectedHexagram(hex)}
            className="bg-bg-input hover:bg-bg-elevated border border-wood-border/40 hover:border-wood-accent rounded-lg p-3 text-center cursor-pointer transition-all duration-150 active:scale-[0.98]"
          >
            <div className="text-[10px] text-stone-500 font-mono">Quẻ số {hex.number}</div>
            <div className="text-2xl text-wood-accent my-1 leading-none tracking-widest">{hex.symbol}</div>
            <div className="text-xs font-bold text-ivory">{hex.name}</div>
            <div className="text-[10px] text-stone-400 mt-0.5 truncate">{hex.upper} / {hex.lower}</div>
          </div>
        ))}
        {filtered.length === 0 && (
          <div className="col-span-full py-8 text-center text-xs text-stone-500">
            Không tìm thấy quẻ phù hợp với từ khóa "{searchTerm}"
          </div>
        )}
      </div>

      {/* Detail Modal */}
      {selectedHexagram && (
        <div
          className="fixed inset-0 z-50 bg-black/75 backdrop-blur-sm flex items-center justify-center p-4 animate-fadeIn"
          onClick={() => setSelectedHexagram(null)}
        >
          <div
            className="bg-bg-card border border-wood-accent rounded-2xl max-w-md w-full p-5 relative shadow-2xl"
            onClick={(e) => e.stopPropagation()}
          >
            <button
              onClick={() => setSelectedHexagram(null)}
              className="absolute top-4 right-4 text-stone-400 hover:text-white p-1"
            >
              <X className="w-5 h-5" />
            </button>

            <div className="flex items-center gap-2 mb-2">
              <span className="text-2xl text-wood-accent">{selectedHexagram.symbol}</span>
              <div>
                <h3 className="text-base font-bold text-wood-accent">
                  Quẻ số {selectedHexagram.number}: {selectedHexagram.name}
                </h3>
                <div className="flex gap-2 text-[11px] text-stone-400 mt-0.5">
                  <span className="bg-wood-border/30 px-2 py-0.5 rounded">{selectedHexagram.upper} thượng</span>
                  <span className="bg-wood-border/30 px-2 py-0.5 rounded">{selectedHexagram.lower} hạ</span>
                </div>
              </div>
            </div>

            <div className="space-y-3 mt-4 text-xs">
              <div className="bg-bg-input p-3 rounded-lg border border-wood-border/30">
                <span className="font-bold text-wood-accent block mb-1">Ý NGHĨA THOÁN TỪ & BIẾN DỊCH:</span>
                <p className="text-stone-300 leading-relaxed">{selectedHexagram.meaning}</p>
              </div>

              <div className="bg-bg-input p-3 rounded-lg border border-wood-border/30">
                <span className="font-bold text-emerald-400 block mb-1">ỨNG DỤNG PHONG THỦY NHÀ ĐẤT:</span>
                <p className="text-stone-300 leading-relaxed">{selectedHexagram.fengShui}</p>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
