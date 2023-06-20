# frozen_string_literal: true

require 'generator_helpers/cli_helper'
require 'generator_helpers/file_helper'
require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './code_template'

class UjsUtilsGenerator < Rails::Generators::Base
  include Helper
  include CliHelper
  include FileHelper
  include CodeTemplate
  include PackageHelper
  include ContentHelper

  source_root File.expand_path('templates', __dir__)

  class_option :packages,
               aliases: '-p',
               type: :array,
               desc: 'Select specific packages to integrate with @rails/ujs'

  class_option :root,
               aliases: '-r',
               type: :string,
               desc: 'Integrate @rails/ujs into root'

  class_option :jquery,
               type: :string,
               desc: 'Integrate jquery'

  class_option :stimulus,
               type: :string,
               desc: 'Integrate stimulus'

  class_option 'turbo-rails',
               type: :string,
               desc: 'Integrate turbo-rails'

  def generate_ujs_utils
    if options[:root].present?
      generate_content(Rails.root)
      install_packages(true, [])
    end

    existing_packages = []

    packages.each do |package|
      next unless package_exist?(package, log: true)

      existing_packages << package
    end

    return if existing_packages.blank?

    existing_packages.each do |package|
      generate_content("packages/#{package}")
    end

    install_packages(false, existing_packages)
  end

  private

  def generate_content(path)
    setup_file = "#{path}/app/frontend/setup/index.ts"
    application_ts_file = "#{path}/app/frontend/entrypoints/application.ts"
    copy_tt_files(UJS_UTILS_UJS_FILES, path:)

    if invoke_action?
      insert_at_beginning_of_file(
        file: setup_file,
        content: init_ujs_import,
        init: true
      )

      if jquery?
        copy_tt_files(UJS_UTILS_JQUERY_FILES, path:)
        insert_at_beginning_of_file(
          file: setup_file,
          content: init_jquery_import,
          init: true
        )
      end

      if stimulus?
        vite_config_file = "#{path}/vite.config.ts"

        copy_tt_files(UJS_UTILS_STIMULUS_FILES, path:)
        insert_at_end_of_file(
          file: application_ts_file,
          content: controllers_import,
          init: true
        )
        insert_at_beginning_of_file(
          file: vite_config_file,
          content: stimulus_hmr_import
        )
        insert_at_specific_file_content(
          file: vite_config_file,
          spec: 'plugins: [',
          content: stimulus_plugins
        )
      end

      if turbo_rails?
        copy_tt_files(UJS_UTILS_TURBO_RAILS_FILES, path:)
        insert_at_end_of_file(
          file: setup_file,
          content: init_turbo_rails_import,
          init: true
        )
      end
    else
      clean_content(file: setup_file, content: init_ujs_import)

      if jquery?
        copy_tt_files(UJS_UTILS_JQUERY_FILES, path:)
        clean_content(file: setup_file, content: init_jquery_import)
      end

      if turbo_rails?
        copy_tt_files(UJS_UTILS_TURBO_RAILS_FILES, path:)
        clean_content(file: setup_file, content: init_turbo_rails_import)
      end

      if stimulus?
        copy_tt_files(UJS_UTILS_STIMULUS_FILES, path:)
        clean_content(file: application_ts_file, content: controllers_import)
      end
    end
  end

  def install_packages(global, workspaces)
    pnpm_add(install_npm_packages, behavior:, global:, workspaces:)
    pnpm_add(install_npm_dev_packages, behavior:, is_dev: true, global:, workspaces:)
  end
end
