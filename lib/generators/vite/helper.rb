# frozen_string_literal: true

require 'package_helper'

module Helper
  include ActiveSupport::Concern
  include PackageHelper

  MAGIC_COMMENT_REGEX = /((([^\w\d:;\t\r\n]\s?)|^\s?)#\s?(.*(frozen_string_literal:|rubocop:(disable|enable))).+)/
  PRIVATE_REGEX = /^private/
  DEF_REGEX = /^def/
  END_REGEX = /^end/
  CLASS_REGEX = /^class/
  HEAD_ELEMENT_REGEX = %r{^</head>}
  IGNORE_SPACE_REGEX_STR = '(([\t\r\n]\s?)|\s?)'

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

  def insert_application_layout(file, content)
    unless File.exist?(file)
      copy_file('application.html.erb.tt', file)
      return
    end

    file_content = File.read(file)

    return if content_exist?(file_content, content)

    insert_index = 0

    file_content.each_line do |line|
      break if HEAD_ELEMENT_REGEX.match?(line.strip)

      insert_index += line.length
    end

    File.write(file, file_content.insert(insert_index, content))
  end

  def insert_beginning_of_file(file, content)
    file_content = File.read(file)
    return if content_exist?(file_content, content)

    insert_index = 0

    file_content.each_line do |line|
      break unless MAGIC_COMMENT_REGEX.match?(line)

      insert_index += line.length
    end

    File.write(file, file_content.insert(insert_index, content))
  end

  def insert_inside_implement(file, package_name, content, type: :class, template: nil)
    if template.present? && !File.exist?(file)
      template(template, file)
      return
    end

    file_content = File.read(file)
    return if content_exist?(file_content, content)

    insert_index = 0
    hit_count = 0
    matched_resource = false
    signal_regex = Regexp.new("^#{type} #{package_name.camelize}")

    file_content.each_line do |line|
      strip_line = line.strip

      if signal_regex.match?(strip_line)
        matched_resource = true
        hit_count += 1
      elsif CLASS_REGEX.match?(strip_line)
        hit_count += 1
      end

      hit_count += 1 if DEF_REGEX.match?(strip_line)
      hit_count -= 1 if END_REGEX.match?(strip_line)

      break if matched_resource && (PRIVATE_REGEX.match?(strip_line) || hit_count.zero?)

      insert_index += line.length
    end

    File.write(file, file_content.insert(insert_index, "\n#{content}\n"))
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

  def clean_content(file, content)
    return unless File.exist?(file)

    file_content = File.read(file)

    File.write(
      file,
      file_content.gsub(
        content_regex_template(content),
        ''
      )
    )
  end

  private

  def existing_ports
    JSON.parse(Rails.root.join('tmp/vite_ports_cache.json').read)
  rescue StandardError
    {}
  end

  def content_exist?(file_content, content)
    content_regex_template(content).match?(file_content)
  end

  def content_regex_template(content)
    Regexp.new(
      content.split("\n")
           .map(&:strip)
           .reject(&:empty?)
           .map { |c| Regexp.escape(c) }
           .join("#{IGNORE_SPACE_REGEX_STR}+")
    )
  end

  def extract_argv
    packages = options[:packages].presence

    return [] if packages.blank? && options[:root].present?

    if behavior == :invoke
      [ARGV.first]
    else
      [ARGV.second]
    end
  end
end
