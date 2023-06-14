# frozen_string_literal: true

Auth::Engine.routes.draw do
  # If you support api only

  scope 'api/v1' do
    devise_for(
      :auth,
      class_name: 'Auth::User',
      only: %w[sessions],
      controllers: {
        sessions: 'auth/api/v1/auth'
      },
      path_names: {
        sign_in: '',
        sign_out: ''
      }
    )
  end

  # If you don't support api only

  # devise :users, class_name: 'Auth::User'

  # namespace :api do
  #   namespace :v1 do
  #     resources :auth, path: 'auth', only: %i[create]
  #   end
  # end
end
