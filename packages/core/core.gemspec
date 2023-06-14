# frozen_string_literal: true

require_relative 'lib/core/version'

Gem::Specification.new do |spec|
  spec.name                               = 'core'
  spec.version                            = Core::VERSION
  spec.authors                            = ['Dương Tấn Huỳnh Phong']
  spec.email                              = ['alphanolucifer@gmail.com']
  spec.summary                            = 'Core package for rails app'
  spec.description                        = 'Core package for rails app'
  spec.required_ruby_version              = '~> 3.2.2'
  spec.metadata['rubygems_mfa_required']  = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'blueprinter'
  spec.add_dependency 'dry-auto_inject'
  spec.add_dependency 'dry-container'
  spec.add_dependency 'rails', '>= 7.0.4.3'
  spec.add_dependency 'yajl-ruby'
end
