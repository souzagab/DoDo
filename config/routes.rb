Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  resources :sessions, only: %i[index show destroy]
  resource  :password, only: %i[edit update]
  namespace :identity do
    resource :email,              only: %i[edit update]
    resource :email_verification, only: %i[show create]
    resource :password_reset,     only: %i[new edit create update]
  end

  resource :invitation, only: %i[new create]

  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"

  resources :tasks do
    post :search, action: :index, on: :collection
  end

  root "tasks#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "/service-worker.js" => "service_worker#service_worker"
  get "/manifest.json" => "service_worker#manifest"
  resources :devices, only: :create
end
