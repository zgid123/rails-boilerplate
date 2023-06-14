# frozen_string_literal: true

require 'devise'
require 'devise/jwt'

module Auth
  class Engine < ::Rails::Engine
    isolate_namespace Auth
  end
end
