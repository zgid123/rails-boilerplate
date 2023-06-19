# frozen_string_literal: true

require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './code_template'

class UjsUtilsGenerator < Rails::Generators::Base
  include Helper
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

  def create_files
    if options[:root].present?
      application_ts_file = Rails.root.join('app/frontend/entrypoints/application.ts')

      if invoke_action?
        insert_at_beginning_of_file(
          file: application_ts_file,
          content: [jquery_import, rails_ujs_import],
          template_path: 'app/frontend/entrypoints/application.ts.tt'
        )
        insert_at_end_of_file(
          file: application_ts_file,
          content: command_import,
          log: true
        )
      else
        clean_content(file: application_ts_file, content: jquery_import)
        clean_content(file: application_ts_file, content: rails_ujs_import)
        clean_content(file: application_ts_file, content: command_import)
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
      application_ts_file = Rails.root.join("packages/#{package}/app/frontend/entrypoints/application.ts")

      if invoke_action?
        insert_at_beginning_of_file(
          file: application_ts_file,
          content: [jquery_import, rails_ujs_import],
          template_path: 'app/frontend/entrypoints/application.ts.tt'
        )
        insert_at_end_of_file(
          file: application_ts_file,
          content: command_import,
          log: true
        )
      else
        clean_content(file: application_ts_file, content: jquery_import)
        clean_content(file: application_ts_file, content: rails_ujs_import)
        clean_content(file: application_ts_file, content: command_import)
      end
    end
  end
end
