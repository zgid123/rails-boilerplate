# frozen_string_literal: true

require 'package_helper'
require_relative './helper'
require_relative './code_template'

class TailwindGenerator < Rails::Generators::Base
  include PackageHelper
  include Helper
  include CodeTemplate

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

  FILES = %w[
    app/frontend/styles/tailwind.scss.tt
    postcss.config.ts.tt
    tailwind.config.js.tt
  ].freeze

  NPM_PACKAGES = %w[
    @tailwindcss/aspect-ratio
    @tailwindcss/container-queries
    @tailwindcss/forms
    @tailwindcss/typography
    autoprefixer
    postcss
    tailwindcss
  ].freeze

  def create_files
    if options[:root].present?
      copy_tt_files(FILES, path: Rails.root.to_s)

      system("pnpm -w #{npm_command} #{install_npm_packages_str}")

      Rails::Generators.invoke('vite', ['--root']) if behavior == :invoke && options[:'skip-vite'].blank?

      styles_path = Rails.root.join('app/frontend/entrypoints/styles.scss')

      if behavior == :invoke
        insert_beginning_of_styles(styles_path, tailwind_import)
      else
        clean_content(styles_path, tailwind_import)
      end
    end

    installed_packages = []

    packages.each do |package|
      unless package_exist?(package)
        puts "#{package} package is not existing"
        next
      end

      installed_packages << package

      copy_tt_files(FILES, path: "packages/#{package}")
    end

    return if installed_packages.blank?

    first, *rest = installed_packages

    Rails::Generators.invoke('vite', ["--packages=#{first}", *rest]) if behavior == :invoke && options[:'skip-vite'].blank?

    installed_packages.each do |package|
      system("pnpm --filter=#{package} #{npm_command} #{install_npm_packages_str}")

      styles_path = "packages/#{package}/app/frontend/entrypoints/styles.scss"

      if behavior == :invoke
        insert_beginning_of_styles(styles_path, tailwind_import)
      else
        clean_content(styles_path, tailwind_import)
      end
    end
  end

  private

  def install_npm_packages_str
    @install_npm_packages_str ||= NPM_PACKAGES.join(' ')
  end
end
