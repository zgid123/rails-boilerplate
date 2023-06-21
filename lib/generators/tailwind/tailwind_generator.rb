# frozen_string_literal: true

require 'generator_helpers/cli_helper'
require 'generator_helpers/file_helper'
require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './constant'
require_relative './code_template'

class TailwindGenerator < Rails::Generators::Base
  include Helper
  include Constant
  include CliHelper
  include FileHelper
  include CodeTemplate
  include ContentHelper
  include PackageHelper

  source_root File.expand_path('templates', __dir__)

  class_option :packages,
               aliases: '-p',
               type: :array,
               desc: 'Select specific packages to integrate with vite'

  class_option :root,
               aliases: '-r',
               type: :string,
               desc: 'Integrate vite into root'

  class_option 'skip-vite',
               type: :string,
               desc: 'Skip initializing Vite'

  def generate_tailwind
    if options[:root].present?
      generate_content(TAILWIND_FILES, Rails.root)
      invoke_vite(['--root'])
      pnpm_add(TAILWIND_NPM_PACKAGES, behavior:, is_dev: true, global: true)
    end

    existing_packages = []

    packages.each do |package|
      next unless package_exist?(package, log: true)

      existing_packages << package
    end

    return if existing_packages.blank?

    first, *rest = existing_packages
    invoke_vite(["--packages=#{first}", *rest])
    pnpm_add(TAILWIND_NPM_PACKAGES, behavior:, is_dev: true, workspaces: existing_packages)

    existing_packages.each do |package|
      generate_content(TAILWIND_FILES, "packages/#{package}")
    end

    generate_global_styles
  end

  private

  def generate_content(files, path)
    copy_tt_files(files, path:)
    vite_config_file = "#{path}/vite.config.ts"
    styles_path = "#{path}/app/frontend/entrypoints/styles.scss"

    if invoke_action?
      insert_at_beginning_of_file(file: styles_path, content: tailwind_import, init: true)
      insert_at_beginning_of_file(file: vite_config_file, content: join_path_import)
      insert_at_beginning_of_file(
        file: vite_config_file,
        content: package_dir_const,
        custom_magic_regex: /^import/
      )
      insert_at_specific_file_content(
        file: vite_config_file,
        spec: 'allow: [',
        content: server_fs_allow
      )
      insert_at_specific_file_content(
        file: vite_config_file,
        spec: 'alias: {',
        content: resolve_alias
      )
    else
      clean_content(file: styles_path, content: tailwind_import)
      clean_content(file: vite_config_file, content: package_dir_const)
      clean_content(file: vite_config_file, content: resolve_alias)
      clean_content(file: vite_config_file, content: server_fs_allow)
    end
  end

  def generate_global_styles
    return if package_exist?('tailwind_ui')

    copy_tt_files(TAILWIND_GLOBAL_FILES, path: 'packages/tailwind_ui')
  end
end
