# frozen_string_literal: true

module Auth
  module Api
    module V1
      class ProfileController < BaseController
        def show
          render_resource(current_user, serializer: Auth::ProfileSerializer)
        end
      end
    end
  end
end
