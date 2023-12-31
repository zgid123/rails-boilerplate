# frozen_string_literal: true

Auth::Engine.routes.draw do
  scope 'api/v1' do
    devise_for(
      :auth,
      class_name: 'Auth::User',
      only: %i[sessions],
      controllers: {
        sessions: 'auth/api/v1/auth'
      },
      path_names: {
        sign_in: '',
        sign_out: ''
      }
    )
  end

  namespace :api do
    namespace :v1 do
      resource :profile, path: 'auth/profile', controller: 'profile', only: %i[show]
    end
  end

  devise_for :users, path: :auth, class_name: 'Auth::User', only: %i[sessions]

  scope 'auth' do
    resource :profile, controller: 'profile', only: %i[show]
  end
end
