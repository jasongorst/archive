Rails.application.routes.draw do
  root 'display#index'

  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :admin_users, controller: 'clearance/users', only: [:create] do
    resource :password,
      controller: 'clearance/passwords',
      only: [:edit, :update]
  end

  get '/sign_in', to: 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out', to: 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up', to: 'clearance/users#new', as: 'sign_up'

  namespace :admin do
    resources :users
    resources :channels
    resources :messages
    resources :attachments
    resources :admin_users

    root to: 'users#index'
  end

  get 'search', to: 'search#index'
  get '/:channel_id', to: 'display#show', as: :channel
  get '/:channel_id/:date', to: 'display#by_date', as: :channel_date
end
