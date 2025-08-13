Rails.application.routes.draw do
  get "pages/home"
  devise_for :users

  # 認証済みユーザーのルート
  authenticated :user do
    root "events#index", as: :authenticated_root
  end

  # 未認証ユーザーのルート
  unauthenticated do
    root "pages#home"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :tasks,  only: [ :index, :show, :new, :create ]
  resources :events, only: [ :index, :show, :new, :create ]
end
