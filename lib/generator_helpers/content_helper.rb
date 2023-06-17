# frozen_string_literal: true

require_relative './file_helper'

module ContentHelper
  include FileHelper

  MAGIC_COMMENT_REGEX = /((([^\w\d:;\t\r\n]\s?)|^\s?)#\s?(.*(frozen_string_literal:|rubocop:(disable|enable))).+)/
  IGNORE_SPACE_REGEX_STR = '(([\t\r\n]\s?)|\s?)'
  PRIVATE_REGEX = /^private/
  DEF_REGEX = /^def/
  END_REGEX = /^end/
  CLASS_REGEX = /^class/
  MODULE_REGEX = /^module/

  def content_exist?(file_content, content)
    parse_content_as_regex(content).match?(file_content)
  end

  def parse_content_as_regex(content)
    parsed_content = content.split("\n")
                            .map(&:strip)
                            .reject(&:empty?)
                            .map { |c| Regexp.escape(c) }
                            .join("#{IGNORE_SPACE_REGEX_STR}+")

    Regexp.new(parsed_content)
  end

  def insert_at_end_of_file(file:, content:, log: true, template_path: nil, init: false)
    return unless file_exist?(file, log:, template_path:, init:)

    resource, file_content = read_content(file)
    return if content_exist?(file_content, content)

    resource.write("\n#{content}\n", mode: 'a')
  end

  def insert_at_beginning_of_file(file:, content:, log: false, template_path: nil, init: false)
    return unless file_exist?(file, log:, template_path:, init:)

    resource, file_content = read_content(file)
    return if content_exist?(file_content, content)

    insert_index = 0

    file_content.each_line do |line|
      break unless MAGIC_COMMENT_REGEX.match?(line)

      insert_index += line.length
    end

    resource.write(file_content.insert(insert_index, "#{content}\n"))
  end

  def insert_at_specific_module(file:, content:, module_name:, type: :class, log: false, template_path: nil, init: false)
    return unless file_exist?(file, log:, template_path:, init:)

    resource, file_content = read_content(file)
    return if content_exist?(file_content, content)

    insert_index = 0
    hit_count = 0
    matched_resource = false
    signal_regex = Regexp.new("^#{type} #{module_name.camelize}")

    file_content.each_line do |line|
      strip_line = line.strip

      if signal_regex.match?(strip_line)
        matched_resource = true
        hit_count += 1
      elsif matched_resource && ((type == :class && CLASS_REGEX.match?(strip_line)) || (type == :module && MODULE_REGEX.match?(strip_line)))
        hit_count += 1
      end

      hit_count += 1 if DEF_REGEX.match?(strip_line)
      hit_count -= 1 if END_REGEX.match?(strip_line)

      break if matched_resource && (PRIVATE_REGEX.match?(strip_line) || hit_count.zero?)

      insert_index += line.length
    end

    resource.write(file_content.insert(insert_index, "\n#{content}\n"))
  end

  def insert_at_end_of_html_tag(file:, content:, tag:, log: false, template_path: nil, init: false, init_type: :compile)
    return unless file_exist?(file, log:, template_path:, init:, init_type:)

    resource, file_content = read_content(file)
    return if content_exist?(file_content, content)

    insert_index = 0

    file_content.each_line do |line|
      break if Regexp.new("^</#{tag}>").match?(line.strip)

      insert_index += line.length
    end

    resource.write(file_content.insert(insert_index, "\n#{content}\n"))
  end

  def clean_content(file:, content:, log: false)
    return unless file_exist?(file, log:)

    resource, file_content = read_content(file)
    resource.write(
      file_content.gsub(
        parse_content_as_regex(content),
        ''
      )
    )
  end
end
