require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root 'jobs#index'

  authenticated :user do
    root to: 'jobs#index', as: :authenticated_root
  end

  authenticate :user, ->(user) { user } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_scope :user do
    root to: 'devise/sessions#new', as: :unauthenticated_root
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :jobs do
    member do
      patch :start
      patch :pause
    end
  end
  get 'search', to: 'jobs#search'
end
