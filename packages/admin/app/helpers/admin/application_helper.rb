# frozen_string_literal: true

module Admin
  module ApplicationHelper
    def vite_manifest
      Admin::Engine.vite_ruby.manifest
    end
  end
end
