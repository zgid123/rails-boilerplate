# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health', to: 'application#health'
end
