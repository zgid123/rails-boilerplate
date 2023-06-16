# frozen_string_literal: true

module Auth
  module Api
    module V1
      class AuthController < Devise::SessionsController
        include ::Core::Render

        protect_from_forgery with: :null_session

        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render_resource(resource, serializer: Auth::ProfileSerializer)
        end

        def respond_to_on_destroy
          render_resource(
            message: 'Sign out successfully.'
          )
        end
      end
    end
  end
end