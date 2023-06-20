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
  end

  private

  def generate_content(files, path)
    copy_tt_files(files, path:)
    styles_path = "#{path}/app/frontend/entrypoints/styles.scss"

    if invoke_action?
      insert_at_beginning_of_file(file: styles_path, content: tailwind_import, init: true)
    else
      clean_content(file: styles_path, content: tailwind_import)
    end
  end
end
