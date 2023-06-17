# frozen_string_literal: true

module ViteHelper
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
end
