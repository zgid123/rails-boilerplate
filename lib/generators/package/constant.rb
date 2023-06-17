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
end
