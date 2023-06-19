# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    include Core::Inject[
      filter_users_service: 'admin_user_filter_users_service'
    ]

    def index
      @users = filter_users_service.call
    end
  end
end
