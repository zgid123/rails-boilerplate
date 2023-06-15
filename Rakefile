# frozen_string_literal: true

require_relative 'config/application'

Rails.application.load_tasks

package_dir = Rails.root.join('packages')

packages = Dir.entries(package_dir).select do |folder|
  File.directory?("#{package_dir}/#{folder}") && ['.', '..'].exclude?(folder)
end

Rake::Task['assets:precompile'].enhance do |_task|
  packages.each do |package|
    Dir.chdir(Rails.root.join("packages/#{package}")) do
      path = Rails.root.join(ViteRuby.config.vite_bin_path)
      _, stderr, status = [ViteRuby::IO.capture("VITE_RUBY_VITE_BIN_PATH=#{path} bin/vite build")]
      raise stderr unless status
    end
  end
end
