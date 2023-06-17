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

  def cache_vite_ports
    cache_file = Rails.root.join('tmp/vite_ports_cache.json')

    return if File.exist?(cache_file)

    ports = package_folders(pluck: :path).push(Rails.root.to_s).each_with_object({}) do |path, result|
      vite_json_path = "#{path}/config/vite.json"

      next result unless File.exist?(vite_json_path)

      content = JSON.parse(File.read(vite_json_path))
      port = content['development'].try(:[], 'port') || 3036

      result[port.to_s] = port
    end

    cache_file.write(ports.to_json)
  end

  def package_exist?(package)
    Dir.exist?("packages/#{package}")
  end

  def copy_tt_files(files, path:)
    files.each do |file|
      template(file, "#{path}/#{file.gsub('.tt', '')}")
    end
  end
end
