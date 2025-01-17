/** @type {import('tailwindcss').Config} */
import theme from './src/public/theme';
export default {
  content: ['./index.html', './src/*.{vue,js}', './src/**/*.{vue,js}', './src/public/config.yaml'],
  theme,
  plugins: [],
}
