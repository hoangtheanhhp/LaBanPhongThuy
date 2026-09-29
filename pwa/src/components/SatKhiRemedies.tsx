import React, { useState } from 'react';
import { SAT_KHI_LIST } from '../data/fengshui';
import { ShieldAlert, ChevronDown, ChevronUp, AlertCircle, ShieldCheck } from 'lucide-react';

export const SatKhiRemedies: React.FC = () => {
  const [expandedIndex, setExpandedIndex] = useState<number | null>(0);

  const toggle = (idx: number) => {
    setExpandedIndex(expandedIndex === idx ? null : idx);
  };

  return (
    <div className="bg-bg-card border border-wood-border/40 rounded-xl p-4 sm:p-5 shadow-md">
      <div className="flex items-center gap-2 text-wood-accent font-bold text-base mb-2">
        <ShieldAlert className="w-5 h-5 text-rose-500" />
        <h2>Nhận Diện & Hóa Giải Các Thế Sát Ngoại Cảnh</h2>
      </div>
      <p className="text-xs text-stone-400 mb-4 leading-relaxed">
        Thế sát xung quanh nhà ở (Loan đầu) có thể triệt hạ sinh khí và mang lại bất an. Dưới đây là phương thức nhận diện và hóa giải bằng vật phẩm phong thủy chuẩn truyền thống.
      </p>

      <div className="space-y-2.5">
        {SAT_KHI_LIST.map((item, idx) => {
          const isOpen = expandedIndex === idx;
          return (
            <div
              key={idx}
              className="border border-wood-border/40 rounded-lg overflow-hidden bg-bg-input"
            >
              <button
                onClick={() => toggle(idx)}
                className="w-full flex items-center justify-between p-3 text-left font-bold text-xs sm:text-sm text-wood-accent hover:bg-bg-elevated/40 transition-colors"
              >
                <span className="flex items-center gap-2">
                  <span className="text-rose-400">⚠️</span>
                  <span>{item.name}</span>
                </span>
                {isOpen ? (
                  <ChevronUp className="w-4 h-4 text-stone-400" />
                ) : (
                  <ChevronDown className="w-4 h-4 text-stone-400" />
                )}
              </button>

              {isOpen && (
                <div className="p-3 border-t border-wood-border/30 bg-bg-card/50 text-xs space-y-2 animate-fadeIn">
                  <div className="flex items-start gap-1.5 text-rose-300">
                    <AlertCircle className="w-4 h-4 shrink-0 mt-0.5 text-rose-400" />
                    <div>
                      <strong className="text-rose-400">Tác hại: </strong>
                      <span>{item.danger}</span>
                    </div>
                  </div>

                  <div className="flex items-start gap-1.5 text-emerald-300">
                    <ShieldCheck className="w-4 h-4 shrink-0 mt-0.5 text-emerald-400" />
                    <div>
                      <strong className="text-emerald-400">Cách hóa giải: </strong>
                      <span>{item.solution}</span>
                    </div>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};
