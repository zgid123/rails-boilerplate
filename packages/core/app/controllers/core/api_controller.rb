# frozen_string_literal: true

module Core
  class ApiController < ActionController::API
    include Core::Render
    include ::Pagy::Backend
  end
end
