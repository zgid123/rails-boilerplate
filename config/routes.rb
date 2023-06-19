# frozen_string_literal: true

Rails.application.routes.draw do
  mount Auth::Engine, at: ''
  mount Admin::Engine, at: 'admin'

  get '/health', to: 'application#health'
end
