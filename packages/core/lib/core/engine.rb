# frozen_string_literal: true

require 'blueprinter'

module Core
  class Engine < ::Rails::Engine
    isolate_namespace Core
  end
end
