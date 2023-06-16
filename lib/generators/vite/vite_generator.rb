# frozen_string_literal: true

require_relative './helper'
require_relative './code_template'

class ViteGenerator < Rails::Generators::Base
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

  FILES = %w[
    .eslintrc.json.tt
    package.json.tt
    tsconfig.json.tt
    vite.config.ts.tt
    app/frontend/entrypoints/application.ts
    app/frontend/entrypoints/styles.scss
  ].freeze

  def create_package
    return if behavior == :revoke

    cache_vite_ports
    formated_files = []

    packages.each do |package|
      @package_name = package

      FILES.each do |file|
        template(file, "packages/#{package}/#{file.gsub('.tt', '')}")
      end

      vite_json_path = "packages/#{package}/config/vite.json"

      unless File.exist?(vite_json_path)
        template('vite.json.tt', vite_json_path)
        cache_port
      end

      file_names = {
        package_engine: Rails.root.join("packages/#{package}/lib/#{package}/engine.rb"),
        application_helper: Rails.root.join("packages/#{package}/app/helpers/#{package}/application_helper.rb")
      }

      insert_inside_implement(file_names[:package_engine], 'Engine', engine_code, type: :class)
      insert_beginning_of_file(file_names[:package_engine], "\n\nrequire 'vite_rails'\n")
      insert_inside_implement(
        file_names[:application_helper],
        'ApplicationHelper',
        vite_manifest(camelized_package),
        type: :module,
        template: 'application_helper.rb.tt'
      )
      insert_application_layout(
        Rails.root.join("packages/#{package}/app/views/layouts/#{package}/application.html.erb"),
        layout_code
      )

      formated_files.push(*file_names.values)
    end

    system("bundle exec rubocop -f q -a #{formated_files.join(' ')}")
  end

  def clean_package
    return if behavior == :invoke

    formated_files = []

    packages.each do |package|
      @package_name = package

      FILES.each do |file|
        template(file, "packages/#{package}/#{file.gsub('.tt', '')}")
      end

      remove_file("packages/#{package}/config/vite.json")

      file_names = {
        package_engine: Rails.root.join("packages/#{package}/lib/#{package}/engine.rb"),
        application_helper: Rails.root.join("packages/#{package}/app/helpers/#{package}/application_helper.rb")
      }

      clean_content(file_names[:package_engine], engine_code)
      clean_content(file_names[:package_engine], "require 'vite_rails'")
      clean_content(
        file_names[:application_helper],
        vite_manifest(camelized_package)
      )
      clean_content(
        Rails.root.join("packages/#{package}/app/views/layouts/#{package}/application.html.erb"),
        layout_code
      )

      formated_files.push(*file_names.values)
    end

    system("bundle exec rubocop -f q -a #{formated_files.join(' ')}")
  end
end
