# frozen_string_literal: true

module Auth
  module Api
    class BaseController < ::Core::ApiController
      include Auth::ApiHelper

      before_action :authenticate_user!
    end
  end
end
