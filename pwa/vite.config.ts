import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  base: './', // Đường dẫn tương đối để chạy mượt cả trên web lẫn WebView offline
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.ico', 'apple-touch-icon.png', 'mask-icon.svg'],
      manifest: {
        name: 'Tra Cứu Bát Quái Phong Thuỷ',
        short_name: 'PhongThuỷ PWA',
        description: 'Cổng tra cứu Bát Quái, Thước Lỗ Ban, Kinh Dịch và Phong Thuỷ Trực Tuyến',
        theme_color: '#141312',
        background_color: '#141312',
        display: 'standalone',
        orientation: 'portrait',
        icons: [
          {
            src: 'pwa-192x192.png',
            sizes: '192x192',
            type: 'image/png'
          },
          {
            src: 'pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png'
          }
        ]
      },
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg}']
      }
    })
  ]
});
