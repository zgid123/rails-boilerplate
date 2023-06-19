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

  devise_for :users, path: :auth, class_name: 'Auth::User', only: %i[sessions]

  resource :profile, controller: 'profile', only: %i[show]
end
