# frozen_string_literal: true

require 'package_helper'

module Helper
  include ActiveSupport::Concern
  include PackageHelper

  IGNORE_SPACE_REGEX_STR = '(([\t\r\n]\s?)|\s?)'

  def packages
    @packages ||= extract_argv
  end

  def npm_command
    @npm_command ||= behavior == :invoke ? 'remove' : 'add -D'
  end

  def insert_beginning_of_styles(file, content)
    file_content = File.read(file)
    return if content_exist?(file_content, content)

    File.write(file, file_content.insert(0, content))
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

  def extract_argv
    packages = options[:packages].presence

    return [] if packages.blank? && options[:root].present?
    return packages if packages.present?

    if behavior == :invoke
      [ARGV.first]
    else
      [ARGV.second]
    end
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
end
