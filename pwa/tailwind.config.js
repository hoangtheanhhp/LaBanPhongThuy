/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'bg-dark': '#141312',
        'bg-card': '#1E1C1A',
        'bg-elevated': '#282522',
        'bg-input': '#121110',
        'wood-accent': '#C49A6C',
        'wood-border': '#5A4D41',
        'north-red': '#9E2A2B',
        'ivory': '#FAF6EE',
      },
    },
  },
  plugins: [],
}
