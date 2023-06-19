# frozen_string_literal: true

module Auth
  module Api
    module V1
      class AuthController < Devise::SessionsController
        include ::Core::Render

        skip_before_action :verify_authenticity_token

        respond_to :json

        private

        def require_no_authentication
          request.session_options[:skip] = true
        end

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
