import React from 'react';
import { Compass, Ruler, Home, BookOpen, ShieldAlert, Hammer, ScrollText } from 'lucide-react';

export type TabType = 'cung' | 'luban' | 'tamyeu' | 'tuoilamnha' | 'vankhan' | 'iching' | 'satkhi';

interface NavbarProps {
  activeTab: TabType;
  onTabChange: (tab: TabType) => void;
}

export const Navbar: React.FC<NavbarProps> = ({ activeTab, onTabChange }) => {
  const tabs: Array<{ id: TabType; label: string; icon: React.ReactNode }> = [
    { id: 'cung', label: 'Mệnh Quái', icon: <Compass className="w-4 h-4" /> },
    { id: 'tuoilamnha', label: 'Tuổi Làm Nhà', icon: <Hammer className="w-4 h-4" /> },
    { id: 'vankhan', label: 'Văn Khấn', icon: <ScrollText className="w-4 h-4" /> },
    { id: 'luban', label: 'Thước Lỗ Ban', icon: <Ruler className="w-4 h-4" /> },
    { id: 'tamyeu', label: 'Tam Yếu (Bếp/Cửa)', icon: <Home className="w-4 h-4" /> },
    { id: 'iching', label: '64 Quẻ Dịch', icon: <BookOpen className="w-4 h-4" /> },
    { id: 'satkhi', label: 'Hóa Giải Sát', icon: <ShieldAlert className="w-4 h-4" /> },
  ];

  return (
    <>
      <header className="sticky top-0 z-50 bg-gradient-to-b from-[#261614] to-bg-card border-b border-wood-border px-4 py-3 text-center shadow-lg">
        <h1 className="text-base sm:text-lg font-bold text-wood-accent tracking-wide flex items-center justify-center gap-2">
          <span className="text-xl">☯</span> Tra Cứu Bát Quái Phong Thuỷ
        </h1>
        <p className="text-[11px] text-stone-400 mt-0.5">
          Bát Trạch Minh Cảnh · Thước Lỗ Ban · Kinh Dịch Toàn Thư
        </p>
      </header>

      <nav className="sticky top-[61px] z-40 bg-bg-card border-b border-stone-800/80 overflow-x-auto no-scrollbar">
        <div className="flex px-3 py-2 gap-2 max-w-2xl mx-auto">
          {tabs.map((tab) => {
            const isActive = activeTab === tab.id;
            return (
              <button
                key={tab.id}
                onClick={() => onTabChange(tab.id)}
                className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all duration-200 ${
                  isActive
                    ? 'bg-bg-elevated border border-wood-accent text-wood-accent shadow-sm'
                    : 'text-stone-300 hover:text-white border border-transparent'
                }`}
              >
                {tab.icon}
                <span>{tab.label}</span>
              </button>
            );
          })}
        </div>
      </nav>
    </>
  );
};
