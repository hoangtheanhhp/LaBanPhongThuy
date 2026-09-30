import React, { useState } from 'react';
import { Navbar, TabType } from './components/Navbar';
import { CungCalculator } from './components/CungCalculator';
import { LuBanRuler } from './components/LuBanRuler';
import { TamYeuGuide } from './components/TamYeuGuide';
import { IChingLookup } from './components/IChingLookup';
import { SatKhiRemedies } from './components/SatKhiRemedies';
import { BuildingAgeCalculator } from './components/BuildingAgeCalculator';
import { VanKhanLookup } from './components/VanKhanLookup';

export const App: React.FC = () => {
  const [activeTab, setActiveTab] = useState<TabType>('cung');

  return (
    <div className="min-h-screen bg-bg-dark text-ivory flex flex-col">
      <Navbar activeTab={activeTab} onTabChange={setActiveTab} />

      <main className="flex-1 max-w-2xl w-full mx-auto p-3 sm:p-4 pb-12">
        {activeTab === 'cung' && <CungCalculator />}
        {activeTab === 'tuoilamnha' && <BuildingAgeCalculator />}
        {activeTab === 'vankhan' && <VanKhanLookup />}
        {activeTab === 'luban' && <LuBanRuler />}
        {activeTab === 'tamyeu' && <TamYeuGuide />}
        {activeTab === 'iching' && <IChingLookup />}
        {activeTab === 'satkhi' && <SatKhiRemedies />}
      </main>

      <footer className="border-t border-wood-border/30 bg-bg-card/90 py-4 text-center text-[11px] text-stone-500">
        <p>☯ Ứng Dụng Tra Cứu Phong Thuỷ PWA · Tương Thích Web & Mobile WebView</p>
        <p className="text-[10px] text-stone-600 mt-0.5">
          Tài liệu tham khảo: Bát Trạch Minh Cảnh · Dương Trạch Tam Yếu · Chu Dịch Toàn Thư
        </p>
      </footer>
    </div>
  );
};
