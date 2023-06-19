# frozen_string_literal: true

module Auth
  class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    layout 'auth/application'

    def after_sign_in_path_for(*)
      profile_path
    end

    def after_sign_out_path_for(*)
      new_user_session_path
    end
  end
end
