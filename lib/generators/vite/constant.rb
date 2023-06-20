# frozen_string_literal: true

module Constant
  VITE_ROOT_FILES = %w[
    vite.config.ts.tt
    app/frontend/entrypoints/application.ts.tt
    app/frontend/entrypoints/styles.scss.tt
    app/frontend/setup/index.ts.tt
    types/vite-env.d.ts.tt
    bin/vite.tt
  ].freeze

  VITE_FILES = %w[
    .eslintrc.json.tt
    package.json.tt
    tsconfig.json.tt
  ].concat(VITE_ROOT_FILES).freeze
end
