# frozen_string_literal: true

module Auth
  module ApplicationHelper
    def vite_manifest
      Auth::Engine.vite_ruby.manifest
    end
  end
end
