Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  scope '/api' do
    resources :scores, defaults: {format: :json},
                       only: [:index, :show, :create] do
      collection do
        get :countries
      end
    end
  end
  root to: 'home#index'
end
