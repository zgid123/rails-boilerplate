# frozen_string_literal: true

require 'blueprinter'
require 'pagy'

module Core
  class Engine < ::Rails::Engine
    isolate_namespace Core
  end
end
