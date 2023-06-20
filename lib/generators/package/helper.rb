# frozen_string_literal: true

require 'generator_helpers/env_helper'
require_relative './constant'

module Helper
  include ActiveSupport::Concern
  include Constant
  include EnvHelper

  def package_name
    @package_name ||= extract_argv(support: :single_arg)
  end

  def camelized_package
    @camelized_package ||= package_name.camelize
  end

  def rails_prerelease?
    @rails_prerelease ||= options.dev? || options.edge? || options.main?
  end

  def rails_version_specifier(gem_version = Rails.gem_version)
    if gem_version.segments.size == 3 || gem_version.release.segments.size == 3
      "~> #{gem_version}"
    else
      patch = gem_version.segments[0, 3].join('.')
      ["~> #{patch}", ">= #{gem_version}"]
    end
  end

  def ruby_version
    @ruby_version ||= Gem::Version.new(RUBY_VERSION).to_s
  end

  def gemfile_pathname
    @gemfile_pathname ||= Rails.root.join('Gemfile')
  end

  def package_gem_import
    @package_gem_import = "gem '#{package_name}', path: 'packages/#{package_name}'"
  end

  def package_dir
    @package_dir ||= Rails.root.join("packages/#{package_name}")
  end

  def template_files
    copy_files = []
    compile_files = [].concat(PACKAGE_FILES)

    compile_files.concat(PACKAGE_API_FILES) if options['rails-api']

    if options['rails-app']
      copy_files.concat(PACKAGE_APP_COPY_FILES)
      compile_files.concat(PACKAGE_APP_FILES)
    end

    [copy_files, compile_files.uniq]
  end
end
