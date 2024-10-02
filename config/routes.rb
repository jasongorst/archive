Rails.application.routes.draw do
  root to: "display#index", as: :root

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]

  resource :session, controller: "clearance/sessions", only: [:create]
  get "sign_in", to: "clearance/sessions#new", as: "sign_in"
  match "sign_out", to: "clearance/sessions#destroy", via: [:get, :delete], as: "sign_out"

  if Clearance.configuration.allow_sign_up?
    get "sign_up", to: "clearance/users#new", as: "sign_up"
  end

  resources :accounts, controller: "clearance/users", only: Clearance.configuration.user_actions do
    resource :password,
             controller: "clearance/passwords",
             only: [:edit, :update]
  end

  get "oauth", to: "oauth#index", as: :oauth

  mount MissionControl::Jobs::Engine, at: "/jobs"

  namespace :admin do
    root to: "accounts#index"

    resources :accounts
    resources :users
    resources :teams
    resources :bot_users
    resources :channels
    resources :messages
    resources :private_channels
    resources :private_messages
    resources :attachments
  end

  scope "/dm" do
    root to: "dm#index", as: :dms
    get "search", to: "private_search#index", as: :search_dms
    get ":private_channel_id", to: "dm#show", as: :private_channel
    get ":private_channel_id/:date", to: "dm#by_date", as: :private_channel_date
  end

  get "search", to: "search#index", as: :search
  get ":channel_id", to: "display#show", as: :channel
  get ":channel_id/:date", to: "display#by_date", as: :channel_date
end
