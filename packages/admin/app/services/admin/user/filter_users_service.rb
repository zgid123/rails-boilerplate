# frozen_string_literal: true

module Admin
  module User
    class FilterUsersService < ::Core::BaseService
      def call
        Auth::User.all
      end
    end
  end
end
