# frozen_string_literal: true

require_relative 'lib/auth/version'

Gem::Specification.new do |spec|
  spec.name                               = 'auth'
  spec.version                            = Auth::VERSION
  spec.authors                            = ['Dương Tấn Huỳnh Phong']
  spec.email                              = ['alphanolucifer@gmail.com']
  spec.summary                            = 'Auth app'
  spec.description                        = 'Auth app for project'
  spec.required_ruby_version              = '~> 3.2.2'
  spec.metadata['rubygems_mfa_required']  = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'devise'
  spec.add_dependency 'devise-jwt'
  spec.add_dependency 'rails', '>= 7.0.4.3'
  spec.add_dependency 'vite_rails'
end
