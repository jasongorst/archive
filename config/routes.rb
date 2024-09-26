Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedOut.new do
    root to: "sessions#new", as: :signed_out_root
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: "display#index", as: :root
  end

  mount BotServer::Api::Endpoints::AuthEndpoint, at: "/oauth"

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]

  resource :session, controller: "sessions", only: [:create]
  get "sign_in", to: "sessions#new", as: "sign_in"
  match "sign_out", to: "sessions#destroy", via: [:get, :delete], as: "sign_out"
  get "first_sign_in", to: "sessions#first_sign_in", as: "first_sign_in"

  if Clearance.configuration.allow_sign_up?
    get "/sign_up", to: "clearance/users#new", as: "sign_up"
  end

  resources :accounts, controller: "clearance/users", only: Clearance.configuration.user_actions do
    resource :password,
             controller: "clearance/passwords",
             only: [:edit, :update]
  end

  scope "/auth" do
    get "/", to: "auth#confirm"
    get "confirm", to: "auth#confirm", as: :auth_confirm

    resources :teams, only: [:index, :show] do
      resources :users, controller: :bot_users, only: [:index]
    end
  end

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
    root to: "dm#index", as: :dm_root
    get "search", to: "private_search#index", as: :private_channel_search
    get ":private_channel_id", to: "dm#show", as: :private_channel
    get ":private_channel_id/:date", to: "dm#by_date", as: :private_channel_date
  end

  get "search", to: "search#index", as: :search
  get ":channel_id", to: "display#show", as: :channel
  get ":channel_id/:date", to: "display#by_date", as: :channel_date
end
