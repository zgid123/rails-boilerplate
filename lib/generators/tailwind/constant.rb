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

  TAILWIND_GLOBAL_FILES = %w[
    global.scss.tt
    tailwind_base.scss.tt
    tailwind_utilities.scss.tt
    tailwind_components.scss.tt
  ].freeze
end
