# frozen_string_literal: true

module Auth
  module Api
    module V1
      class BaseController < ActionController::API
        protect_from_forgery with: :null_session
      end
    end
  end
end
