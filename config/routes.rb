Rails.application.routes.draw do
  scope '/api' do
    resources :scores, defaults: {format: :json},
                       only: [:index, :show, :create] do
      collection do
        get :countries
      end
    end
  end
  root to: redirect('/api/scores.json')
end
