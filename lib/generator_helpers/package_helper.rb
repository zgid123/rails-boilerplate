# frozen_string_literal: true

module PackageHelper
  EXCLUDE_FOLDER_NAMES = ['.', '..'].freeze

  def package_folders(pluck: :name)
    package_dir = Rails.root.join('packages')

    Dir.entries(package_dir).each_with_object([]) do |folder, result|
      next result if EXCLUDE_FOLDER_NAMES.include?(folder)

      result << (pluck == :name ? folder : "#{package_dir}/#{folder}")
    end
  end

  def package_exist?(package, log: false)
    if Dir.exist?("packages/#{package}")
      true
    else
      puts "#{package} package is not existing" if log

      false
    end
  end
end
