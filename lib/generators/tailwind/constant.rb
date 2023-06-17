# frozen_string_literal: true

module Constant
  FILES = %w[
    app/frontend/styles/tailwind.scss.tt
    postcss.config.ts.tt
    tailwind.config.js.tt
  ].freeze

  NPM_PACKAGES = %w[
    @tailwindcss/aspect-ratio
    @tailwindcss/container-queries
    @tailwindcss/forms
    @tailwindcss/typography
    autoprefixer
    postcss
    tailwindcss
  ].freeze
end
