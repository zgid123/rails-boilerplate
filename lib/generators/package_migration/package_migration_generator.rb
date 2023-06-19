# frozen_string_literal: true

require 'generator_helpers/env_helper'
require 'generator_helpers/package_helper'

class PackageMigrationGenerator < Rails::Generators::Base
  include EnvHelper
  include PackageHelper

  source_root File.expand_path('templates', __dir__)

  def create_migration
    return if revoke_action?

    validate_params

    Dir.chdir(package_dir) do
      Rails::Generators.invoke('migration', [migration_name])
    end
  end

  def remove_migration
    return if invoke_action?

    validate_params

    Dir.chdir(package_dir) do
      Rails::Generators.invoke('migration', [migration_name], behavior: :revoke)
    end
  end

  private

  def package_name
    @package_name ||= invoke_action? ? ARGV[0] : ARGV[1]
  end

  def migration_name
    @migration_name ||= invoke_action? ? ARGV[1] : ARGV[2]
  end

  def package_dir
    @package_dir ||= "packages/#{package_name}"
  end

  def validate_params
    raise 'Package name is required' if package_name.blank?
    raise "Package #{package_name} is not existed" unless package_exist?(package_name)
    raise 'Migration name is required' if migration_name.blank?
  end
end
