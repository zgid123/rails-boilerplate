# frozen_string_literal: true

require 'generator_helpers/file_helper'
require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './code_template'

class TailwindGenerator < Rails::Generators::Base
  include Helper
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

  def create_files
    if options[:root].present?
      copy_tt_files(FILES, path: Rails.root.to_s)
      system("pnpm -w #{npm_command} #{install_npm_packages_str}")
      invoke_vite(['--root'])
      styles_path = Rails.root.join('app/frontend/entrypoints/styles.scss')

      if invoke_action?
        insert_at_beginning_of_file(file: styles_path, content: tailwind_import, init: true)
      else
        clean_content(file: styles_path, content: tailwind_import)
      end
    end

    installed_packages = []

    packages.each do |package|
      next unless package_exist?(package, log: true)

      installed_packages << package
      copy_tt_files(FILES, path: "packages/#{package}")
    end

    return if installed_packages.blank?

    first, *rest = installed_packages
    invoke_vite(["--packages=#{first}", *rest])

    installed_packages.each do |package|
      system("pnpm --filter=#{package} #{npm_command} #{install_npm_packages_str}")
      styles_path = "packages/#{package}/app/frontend/entrypoints/styles.scss"

      if invoke_action?
        insert_at_beginning_of_file(file: styles_path, content: tailwind_import, init: true)
      else
        clean_content(file: styles_path, content: tailwind_import)
      end
    end
  end
end
