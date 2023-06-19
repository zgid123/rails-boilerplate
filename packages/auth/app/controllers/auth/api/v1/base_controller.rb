# frozen_string_literal: true

module Auth
  module Api
    module V1
      class BaseController < ActionController::API
        include Auth::ApiHelper
        include Core::Render

        before_action :authenticate_user!
      end
    end
  end
end
