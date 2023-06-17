# frozen_string_literal: true

module FileHelper
  def copy_tt_files(files, path:)
    files.each do |file|
      template(file, "#{path}/#{file.gsub('.tt', '')}")
    end
  end

  def file_exist?(file, log: false, template_path: nil, init: false, init_type: :compile)
    resource = convert_pathname(file)
    return true if resource.exist?

    p "#{resource} does not exist" if log && (template_path.blank? || !init)

    if template_path.present?
      template(template_path, resource.to_s) if init_type == :compile
      copy_file(template_path, resource.to_s) if init_type == :copy
      return true
    end

    if init
      resource.write('')
      return true
    end

    false
  end

  def read_content(file)
    resource = convert_pathname(file)

    [resource, resource.read]
  end

  private

  def convert_pathname(file)
    if file.is_a?(Pathname)
      file
    else
      Rails.root.join(file)
    end
  end
end
