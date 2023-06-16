# frozen_string_literal: true

require_relative './helper'

class PackageGenerator < Rails::Generators::Base
  include Helper

  source_root File.expand_path('templates', __dir__)

  FILES = %w[
    %package_name%.gemspec.tt
    Rakefile.tt
    Gemfile.tt
    lib/%package_name%.rb.tt
    lib/%package_name%/engine.rb.tt
    lib/%package_name%/version.rb.tt
    bin/rails.tt
  ].freeze

  def create_package
    return if behavior == :revoke

    FILES.each do |file|
      template(file, "packages/#{package_name}/#{file.gsub('.tt', '')}")
    end

    gemfile_pathname.write("\n#{package_gem_import}\n", mode: 'a')
    system("bundle exec rubocop -f q -a #{gemfile_pathname}")
  end

  def clean_package
    return if behavior == :invoke

    return unless yes?("Are you sure you want to delete the #{package_name} package? (Y/N)")

    dir_path = Rails.root.join("packages/#{package_name}")

    return unless Dir.exist?(dir_path)

    directory(dir_path) # for notification
    FileUtils.remove_dir(dir_path) # remove empty folder
    content = gemfile_pathname.read
    gemfile_pathname.write(content.gsub(package_gem_import, ''))
    system("bundle exec rubocop -f q -a #{gemfile_pathname}")
  end
end
