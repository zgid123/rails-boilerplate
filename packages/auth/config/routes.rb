# frozen_string_literal: true

Auth::Engine.routes.draw do
  # If you support api only

  # scope 'api/v1' do
  #   devise_for(
  #     :auth,
  #     class_name: 'Auth::User',
  #     only: %w[sessions],
  #     controllers: {
  #       sessions: 'auth/api/v1/auth'
  #     },
  #     path_names: {
  #       sign_in: '',
  #       sign_out: ''
  #     }
  #   )
  # end

  # If you support both api and web

  devise_for :auth, class_name: 'Auth::User', only: %i[sessions]

  namespace :api do
    namespace :v1 do
      resource :auth, path: 'auth', only: %i[create destroy]
    end
  end
end
