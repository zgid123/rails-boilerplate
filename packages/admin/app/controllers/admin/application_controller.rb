# frozen_string_literal: true

module Admin
  class ApplicationController < ::Core::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      redirect_to '/' unless current_user.has_role?(:admin)
    end
  end
end
