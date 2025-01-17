import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import svgLoader from 'vite-svg-loader';
import vue from '@vitejs/plugin-vue'
import VueDevTools from 'vite-plugin-vue-devtools'
import ViteYaml from '@modyfi/vite-plugin-yaml'

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: '127.0.0.1',
    port: 8080,
    watch: {
      usePolling: true,
    }
  },
  plugins: [
    svgLoader(),
    VueDevTools(),
    vue(),
    ViteYaml(),
  ],
  publicDir: './src/public/',
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  }
})
