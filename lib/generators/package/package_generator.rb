# frozen_string_literal: true

require 'generator_helpers/file_helper'
require 'generator_helpers/content_helper'
require 'generator_helpers/package_helper'
require_relative './helper'
require_relative './constant'

class PackageGenerator < Rails::Generators::Base
  include Helper
  include Constant
  include FileHelper
  include ContentHelper
  include PackageHelper

  source_root File.expand_path('templates', __dir__)

  def create_package
    return if revoke_action?

    copy_tt_files(FILES, path: package_dir)
    insert_at_end_of_file(file: gemfile_pathname, content: package_gem_import)
    format_gemfile
  end

  def clean_package
    return if invoke_action?

    return unless yes?("Are you sure you want to delete the #{package_name} package? (Y/N)")
    return unless package_exist?(package_name)

    directory(package_dir) # for notification
    FileUtils.remove_dir(package_dir) # remove empty folder
    clean_content(file: gemfile_pathname, content: package_gem_import)
    format_gemfile
  end
end
