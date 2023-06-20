# frozen_string_literal: true

module Constant
  FILES = %w[
    %package_name%.gemspec.tt
    Rakefile.tt
    Gemfile.tt
    lib/%package_name%.rb.tt
    lib/%package_name%/engine.rb.tt
    lib/%package_name%/version.rb.tt
    bin/rails.tt
  ].freeze

  API_FILES = %w[
    app/controllers/%package_name%/api/base_controller.rb.tt
    config/routes.rb.tt
  ].freeze

  APP_FILES = %w[
    app/controllers/%package_name%/application_controller.rb.tt
    app/helpers/%package_name%/application_helper.rb.tt
    config/routes.rb.tt
  ].freeze

  APP_COPY_FILES = %w[
    app/views/layouts/%package_name%/application.html.erb.tt
  ].freeze
end
