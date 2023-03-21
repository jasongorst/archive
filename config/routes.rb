Rails.application.routes.draw do
  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :admin_users, controller: 'clearance/users', only: [:create] do
    resource :password,
      controller: 'clearance/passwords',
      only: [:edit, :update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'

  namespace :admin do
    resources :users
    resources :channels
    resources :messages
    resources :attachments
    resources :admin_users

    root to: 'users#index'
  end

  root 'display#index'
  get 'search', to: 'search#index'
  get '/:channel_id', to: 'display#show', as: :channel
  get '/:channel_id/:date', to: 'display#by_date', as: :channel_date

  get 'display/index'
  get 'display/show'
end
