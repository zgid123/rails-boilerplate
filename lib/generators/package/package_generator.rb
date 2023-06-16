# frozen_string_literal: true

module Helper
  include ActiveSupport::Concern

  def package_name
    @package_name ||= behavior == :invoke ? ARGV.first : ARGV.second
  end

  def camelized_package
    @camelized_package ||= package_name.camelize
  end

  def rails_prerelease?
    @rails_prerelease ||= options.dev? || options.edge? || options.main?
  end

  def rails_version_specifier(gem_version = Rails.gem_version)
    if gem_version.segments.size == 3 || gem_version.release.segments.size == 3
      "~> #{gem_version}"
    else
      patch = gem_version.segments[0, 3].join('.')
      ["~> #{patch}", ">= #{gem_version}"]
    end
  end

  def ruby_version
    @ruby_version ||= Gem::Version.new(RUBY_VERSION).to_s
  end

  def gemfile_pathname
    @gemfile_pathname = Rails.root.join('Gemfile')
  end

  def package_gem_import
    @package_gem_import = "gem '#{package_name}', path: 'packages/#{package_name}'"
  end
end

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
    system("bundle exec rubocop -a #{gemfile_pathname}")
  end

  def clean_package
    return if behavior == :invoke

    return unless yes?("Are you sure you want to delete the #{package_name} package? (Y/N)")

    dir_path = Rails.root.join("packages/#{package_name}")

    return unless Dir.exist?(dir_path)

    directory(dir_path) # for notification
    FileUtils.remove_dir(dir_path) # remove empty folder
    content = gemfile_pathname.read
    Rails.root.join('Gemfile').write(content.gsub(package_gem_import, ''))
    system("bundle exec rubocop -a #{Rails.root.join('Gemfile')}")
  end
end
