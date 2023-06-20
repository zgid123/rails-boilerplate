# frozen_string_literal: true

module Constant
  NPM_PACKAGES = %w[
    @rails/ujs
  ].freeze

  NPM_DEV_PACKAGES = %w[
    @types/rails__ujs
  ].freeze

  STIMULUS_PACKAGES = %w[
    @hotwired/stimulus
    stimulus-vite-helpers
    vite-plugin-stimulus-hmr
  ].freeze

  JQUERY_PACKAGES = %w[
    jquery
  ].freeze

  JQUERY_DEV_PACKAGES = %w[
    @types/jquery
  ].freeze

  TURBO_RAILS_PACKAGES = %w[
    @hotwired/turbo
  ].freeze

  UJS_FILES = %w[
    app/frontend/setup/init_ujs.ts.tt
  ].freeze

  JQUERY_FILES = %w[
    app/frontend/setup/init_jquery.ts.tt
  ].freeze

  STIMULUS_FILES = %w[
    app/frontend/controllers/index.ts.tt
  ].freeze

  TURBO_RAILS_FILES = %w[
    app/frontend/setup/init_turbo_rails.ts.tt
  ].freeze
end
