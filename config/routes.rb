Rails.application.routes.draw do
  mount BotServer::Api::Endpoints::AuthEndpoint, at: "/oauth"

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  get "/sign_in", to: "clearance/sessions#new", as: "sign_in"

  if Clearance.configuration.allow_sign_up?
    get "/sign_up", to: "clearance/users#new", as: "sign_up"
  end

  get "auth/confirm"

  scope "/auth" do
    resources :teams, only: [:index, :show] do
      resources :users, controller: :bot_users, only: [:index]
    end
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: "clearance/sessions#new", as: :root
  end

  constraints Clearance::Constraints::SignedIn.new do
    root to: "display#index", as: :signed_in_root

    resources :accounts, controller: "clearance/users", only: Clearance.configuration.user_actions do
      resource :password,
               controller: "clearance/passwords",
               only: [:edit, :update]
    end

    match "/sign_out", to: "clearance/sessions#destroy", via: [:get, :delete], as: "sign_out"

    namespace :admin do
      resources :users
      resources :channels
      resources :messages
      resources :attachments
      resources :accounts

      root to: "users#index"
    end

    get "bot_users/index"
    get "users/index"
    get "teams/index"
    get "teams/show"

    scope "/dm" do
      get "/", to: "dm#index"
      get ":private_channel_id", to: "dm#show", as: :private_channel
      get ":private_channel_id/:date", to: "dm#by_date", as: :private_channel_date
      get "search", to: "dm#search", as: :private_channel_search
    end

    get "search", to: "search#index"
    get ":channel_id", to: "display#show", as: :channel
    get ":channel_id/:date", to: "display#by_date", as: :channel_date
  end
end
