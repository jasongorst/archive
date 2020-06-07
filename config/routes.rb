Rails.application.routes.draw do
  root 'display#index'
  get 'search', to: 'search#index'
  get '/:channel_id', to: 'display#show', as: :channel
  get '/:channel_id/:date', to: 'display#show_by_date'

  get 'display/index'
  get 'display/show'
  # resources :messages
  # resources :users
  # resources :channels
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
