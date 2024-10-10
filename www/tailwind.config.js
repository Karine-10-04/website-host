/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/*.{vue,js}', './src/**/*.{vue,js}'],
  theme: {
    extend: {
      fontFamily: {
        neutra: ['Neutra'],
        'neutra-condensed': ['NeutraCondensed'],
        'neutra-medium': ['NeutraMedium'],
        'neutra-thin': ['NeutraThin']
      },
    },
  },
  plugins: [],
}

