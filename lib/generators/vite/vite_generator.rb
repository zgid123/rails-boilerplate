# frozen_string_literal: true

require 'generator_helpers/cli_helper'
require 'generator_helpers/file_helper'
require 'generator_helpers/vite_helper'
require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './constant'
require_relative './code_template'

class ViteGenerator < Rails::Generators::Base
  include Helper
  include Constant
  include CliHelper
  include FileHelper
  include ViteHelper
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

  def create_vite
    return if revoke_action?

    cache_vite_ports
    formated_files = []

    create_major_files(VITE_ROOT_FILES, path: Rails.root) if options[:root].present?

    packages.each do |package|
      next unless package_exist?(package, log: true)

      @package_name = package
      package_dir = "packages/#{package}"
      create_major_files(VITE_FILES, path: package_dir)

      file_names = {
        package_engine: Rails.root.join("#{package_dir}/lib/#{package}/engine.rb"),
        application_helper: Rails.root.join("#{package_dir}/app/helpers/#{package}/application_helper.rb")
      }

      insert_at_specific_module(
        file: file_names[:package_engine],
        content: engine_code,
        module_name: 'Engine',
        type: :class,
        log: true
      )
      insert_at_beginning_of_file(
        file: file_names[:package_engine],
        content: "\n\n#{require_vite_rails}\n",
        log: true
      )
      insert_at_specific_module(
        file: file_names[:application_helper],
        content: vite_manifest(camelized_package),
        module_name: 'ApplicationHelper',
        type: :module,
        template_path: 'application_helper.rb.tt'
      )
      insert_at_end_of_html_tag(
        file: "#{package_dir}/app/views/layouts/#{package}/application.html.erb",
        content: layout_code,
        tag: :head,
        template_path: 'application.html.erb.tt',
        init_type: :copy
      )

      formated_files.push(*file_names.values)
    end

    rubocop_on(formated_files)
  end

  def clean_vite
    return if invoke_action?

    formated_files = []

    create_major_files(VITE_ROOT_FILES, path: Rails.root, clean_port: true) if options[:root].present?

    packages.each do |package|
      @package_name = package
      package_dir = "packages/#{package}"
      create_major_files(VITE_FILES, path: package_dir, clean_port: true)

      file_names = {
        package_engine: Rails.root.join("#{package_dir}/lib/#{package}/engine.rb"),
        application_helper: Rails.root.join("#{package_dir}/app/helpers/#{package}/application_helper.rb")
      }

      clean_content(file: file_names[:package_engine], content: engine_code)
      clean_content(file: file_names[:package_engine], content: require_vite_rails)
      clean_content(
        file: file_names[:application_helper],
        content: vite_manifest(camelized_package)
      )
      clean_content(
        file: "#{package_dir}/app/views/layouts/#{package}/application.html.erb",
        content: layout_code
      )

      formated_files.push(*file_names.values)
    end

    rubocop_on(formated_files)
  end
end
