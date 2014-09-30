Rails.application.routes.draw do
  resources :scores, defaults: {format: :json}, only: [:index, :show, :create]
  root 'scores#index'
end
