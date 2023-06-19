# frozen_string_literal: true

module Core
  class ApplicationController < ActionController::Base
    include ::Pagy::Backend
  end
end
