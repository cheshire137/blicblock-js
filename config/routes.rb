Rails.application.routes.draw do
  scope '/api' do
    resources :scores, defaults: {format: :json}, only: [:index, :show, :create]
  end
  root to: redirect('/api/scores.json')
end
