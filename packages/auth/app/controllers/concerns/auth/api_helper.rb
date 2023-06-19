# frozen_string_literal: true

module Auth
  module ApiHelper
    extend ActiveSupport::Concern

    protected

    def current_user
      current_auth
    end

    def authenticate_user!
      authenticate_auth!
    end

    # in case auth is optional
    def authenticate_user
      authenticate_auth!
    rescue StandardError
      nil
    end
  end
end
