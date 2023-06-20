# frozen_string_literal: true

module Constant
  TAILWIND_FILES = %w[
    app/frontend/styles/tailwind.scss.tt
    postcss.config.ts.tt
    tailwind.config.js.tt
  ].freeze

  TAILWIND_NPM_PACKAGES = %w[
    autoprefixer
    postcss
    tailwindcss
  ].freeze
end
