import { join } from 'path';
import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';

const tailwindUiDir = join(__dirname, '../tailwind_ui');

export default defineConfig({
  plugins: [RubyPlugin()],
  resolve: {
    alias: {
      tailwindUi: tailwindUiDir,
    },
  },
  server: {
    fs: {
      allow: [tailwindUiDir],
    },
  },
});
