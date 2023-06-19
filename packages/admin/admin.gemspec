# frozen_string_literal: true

require_relative 'lib/admin/version'

Gem::Specification.new do |spec|
  spec.name                               = 'admin'
  spec.version                            = Admin::VERSION
  spec.authors                            = ['Dương Tấn Huỳnh Phong']
  spec.email                              = ['alphanolucifer@gmail.com']
  spec.summary                            = 'Admin package for rails app'
  spec.description                        = 'Admin package for rails app'
  spec.required_ruby_version              = '~> 3.2.2'
  spec.metadata['rubygems_mfa_required']  = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '~> 7.0.5'
end
