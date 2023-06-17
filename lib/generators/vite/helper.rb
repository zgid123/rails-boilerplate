# frozen_string_literal: true

require 'generator_helpers/env_helper'

module Helper
  include ActiveSupport::Concern
  include EnvHelper

  def packages
    @packages ||= extract_argv
  end

  def next_port
    existing_ports.values.max + 1
  end

  def package_name
    @package_name
  end

  def camelized_package
    @package_name.camelize
  end

  def create_vite_json(file_path, clean_port: false)
    return if File.exist?(file_path)

    if clean_port
      clean_cache_port(file_path)
    else
      cache_port
    end

    template('vite.json.tt', file_path)
  end

  private

  def existing_ports
    JSON.parse(Rails.root.join('tmp/vite_ports_cache.json').read)
  rescue StandardError
    {}
  end

  def cache_port
    cache_file = Rails.root.join('tmp/vite_ports_cache.json')
    content = JSON.parse(cache_file.read)
    port = next_port
    content[port.to_s] = port
    cache_file.write(content.to_json)
  end

  def clean_cache_port(vite_json_path)
    cache_file = Rails.root.join('tmp/vite_ports_cache.json')

    return if !cache_file.exist? || !File.exist?(vite_json_path)

    content = JSON.parse(cache_file.read)
    vite_content = JSON.parse(File.read(vite_json_path))

    cache_file.write(
      content.except(
        (vite_content['development'].try(:[], 'port').presence || '3036').to_s
      ).to_json
    )
  end
end
