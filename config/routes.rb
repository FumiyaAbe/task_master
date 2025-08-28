Rails.application.routes.draw do
  get "pages/home"
  devise_for :users

  # ▼ ルート専用ページ（Dashboard：カレンダー）
  # 直接アクセス用のパス（root とは別に /dashboard でも開ける）
  get "dashboard", to: "dashboards#home", as: :dashboard

  # ▼ 日別ページ: /day/YYYY-MM-DD → DaysController#show
  get "day/:date", to: "days#show",
      as: :day,
      constraints: { date: /\d{4}-\d{2}-\d{2}/ }

  # 認証済みユーザーのルート
  authenticated :user do
    # ルートを DashboardsController#home に変更（カレンダー表示）
    root "dashboards#home", as: :authenticated_root
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

  # ▼ フルCRUDに変更（edit/update/destroy を含む）
  resources :tasks
  resources :events
end
