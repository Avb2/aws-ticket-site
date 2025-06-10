import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@aws-amplify/auth': '@aws-amplify/auth',
      '@aws-amplify/core': '@aws-amplify/core',
    },
  },
  optimizeDeps: {
    include: ['@aws-amplify/auth', '@aws-amplify/core'],
  },
});