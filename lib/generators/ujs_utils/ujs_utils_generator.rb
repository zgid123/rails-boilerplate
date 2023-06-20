# frozen_string_literal: true

require 'generator_helpers/file_helper'
require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './code_template'

class UjsUtilsGenerator < Rails::Generators::Base
  include Helper
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

  def create_files
    if options[:root].present?
      setup_file = Rails.root.join('app/frontend/setup/index.ts')
      application_ts_file = Rails.root.join('app/frontend/entrypoints/application.ts')
      copy_tt_files(UJS_FILES, path: Rails.root)

      if invoke_action?
        insert_at_beginning_of_file(
          file: setup_file,
          content: init_ujs_import,
          init: true
        )

        if jquery?
          copy_tt_files(JQUERY_FILES, path: Rails.root)
          insert_at_beginning_of_file(
            file: setup_file,
            content: init_jquery_import,
            init: true
          )
        end

        if stimulus?
          copy_tt_files(STIMULUS_FILES, path: Rails.root)
          insert_at_end_of_file(
            file: application_ts_file,
            content: controllers_import,
            init: true
          )
        end

        if turbo_rails?
          copy_tt_files(TURBO_RAILS_FILES, path: Rails.root)
          insert_at_end_of_file(
            file: setup_file,
            content: init_turbo_rails_import,
            init: true
          )
        end
      else
        clean_content(file: setup_file, content: init_ujs_import)

        if jquery?
          copy_tt_files(JQUERY_FILES, path: Rails.root)
          clean_content(file: setup_file, content: init_jquery_import)
        end

        if turbo_rails?
          copy_tt_files(TURBO_RAILS_FILES, path: Rails.root)
          clean_content(file: setup_file, content: init_turbo_rails_import)
        end

        if stimulus?
          copy_tt_files(STIMULUS_FILES, path: Rails.root)
          clean_content(file: application_ts_file, content: controllers_import)
        end
      end

      system("pnpm -w #{npm_command} #{install_npm_packages_str}")
      system("pnpm -w #{npm_command(is_dev: true)} #{install_npm_dev_packages_str}")
    end

    installed_packages = []

    packages.each do |package|
      next unless package_exist?(package, log: true)

      installed_packages << package
    end

    return if installed_packages.blank?

    installed_packages.each do |package|
      system("pnpm --filter=#{package} #{npm_command} #{install_npm_packages_str}")
      system("pnpm --filter=#{package} #{npm_command(is_dev: true)} #{install_npm_dev_packages_str}")
      setup_file = Rails.root.join("packages/#{package}/app/frontend/setup/index.ts")
      application_ts_file = Rails.root.join("packages/#{package}/app/frontend/entrypoints/application.ts")
      copy_tt_files(UJS_FILES, path: "packages/#{package}")

      if invoke_action?
        insert_at_beginning_of_file(
          file: setup_file,
          content: init_ujs_import,
          init: true
        )

        if jquery?
          copy_tt_files(JQUERY_FILES, path: "packages/#{package}")
          insert_at_beginning_of_file(
            file: setup_file,
            content: init_jquery_import,
            init: true
          )
        end

        if stimulus?
          copy_tt_files(STIMULUS_FILES, path: "packages/#{package}")
          insert_at_end_of_file(
            file: application_ts_file,
            content: controllers_import,
            init: true
          )
        end

        if turbo_rails?
          copy_tt_files(TURBO_RAILS_FILES, path: "packages/#{package}")
          insert_at_end_of_file(
            file: setup_file,
            content: init_turbo_rails_import,
            init: true
          )
        end
      else
        clean_content(file: setup_file, content: init_ujs_import)

        if jquery?
          copy_tt_files(JQUERY_FILES, path: "packages/#{package}")
          clean_content(file: setup_file, content: init_jquery_import)
        end

        if turbo_rails?
          copy_tt_files(TURBO_RAILS_FILES, path: "packages/#{package}")
          clean_content(file: setup_file, content: init_turbo_rails_import)
        end

        if stimulus?
          copy_tt_files(STIMULUS_FILES, path: "packages/#{package}")
          clean_content(file: application_ts_file, content: controllers_import)
        end
      end
    end
  end
end
