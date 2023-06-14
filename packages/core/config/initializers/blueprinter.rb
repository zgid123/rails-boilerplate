# frozen_string_literal: true

require 'yajl'

Blueprinter.configure do |config|
  config.generator = Yajl::Encoder
  config.method = :encode
end
