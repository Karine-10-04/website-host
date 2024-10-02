import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import svgLoader from 'vite-svg-loader';
import vue from '@vitejs/plugin-vue'
import VueDevTools from 'vite-plugin-vue-devtools'

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: '172.105.4.192.nip.io',
    port: 8080,
    watch: {
      usePolling: true,
    }
  },
  plugins: [
    svgLoader(),
    VueDevTools(), 
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  }
})
