import { defineConfig, loadEnv, type ConfigEnv, type UserConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

// https://vitejs.dev/config/
export default defineConfig(({ mode }: ConfigEnv): UserConfig => {
  const env = loadEnv(mode, process.cwd())

  return {
    base: '/',
    plugins: [
      vue(),
      // 自动导入 Element Plus 组件
      AutoImport({
        imports: ['vue', 'vue-router', 'pinia'],
        resolvers: [ElementPlusResolver()],
        dts: 'src/types/auto-imports.d.ts',
        eslintrc: {
          enabled: true,
        },
      }),
      Components({
        resolvers: [ElementPlusResolver()],
        dts: 'src/types/components.d.ts',
      }),
    ],
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src'),
      },
    },
    server: {
      port: 3000,
      host: true,
      proxy: {
        '/api': {
          target: 'http://localhost:8080',
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
        },
      },
    },
    build: {
      outDir: 'dist',
      sourcemap: false,
      chunkSizeWarningLimit: 1500,
      rollupOptions: {
        output: {
          manualChunks: {
            'element-plus': ['element-plus'],
            'vue-vendor': ['vue', 'vue-router', 'pinia'],
          },
        },
      },
    },
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `@use "@/styles/variables.scss" as *;`,
        },
      },
    },
  }
})
