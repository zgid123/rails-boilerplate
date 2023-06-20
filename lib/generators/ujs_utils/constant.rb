# frozen_string_literal: true

module Constant
  UJS_UTILS_NPM_PACKAGES = %w[
    @rails/ujs
  ].freeze

  UJS_UTILS_NPM_DEV_PACKAGES = %w[
    @types/rails__ujs
  ].freeze

  UJS_UTILS_STIMULUS_PACKAGES = %w[
    @hotwired/stimulus
    stimulus-vite-helpers
    vite-plugin-stimulus-hmr
  ].freeze

  UJS_UTILS_JQUERY_PACKAGES = %w[
    jquery
  ].freeze

  UJS_UTILS_JQUERY_DEV_PACKAGES = %w[
    @types/jquery
  ].freeze

  UJS_UTILS_TURBO_RAILS_PACKAGES = %w[
    @hotwired/turbo
  ].freeze

  UJS_UTILS_UJS_FILES = %w[
    app/frontend/setup/init_ujs.ts.tt
  ].freeze

  UJS_UTILS_JQUERY_FILES = %w[
    app/frontend/setup/init_jquery.ts.tt
  ].freeze

  UJS_UTILS_STIMULUS_FILES = %w[
    app/frontend/controllers/index.ts.tt
  ].freeze

  UJS_UTILS_TURBO_RAILS_FILES = %w[
    app/frontend/setup/init_turbo_rails.ts.tt
  ].freeze
end
