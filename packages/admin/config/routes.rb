# frozen_string_literal: true

Admin::Engine.routes.draw do
  resources :users, only: %i[index]
end
