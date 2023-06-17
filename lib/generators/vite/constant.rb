# frozen_string_literal: true

module Constant
  ROOT_FILES = %w[
    vite.config.ts.tt
    app/frontend/entrypoints/application.ts
    app/frontend/entrypoints/styles.scss
    bin/vite.tt
  ].freeze

  FILES = %w[
    .eslintrc.json.tt
    package.json.tt
    tsconfig.json.tt
  ].concat(ROOT_FILES).freeze
end
