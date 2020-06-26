Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :admins
  root 'display#index'
  get 'search', to: 'search#index'
  get '/:channel_id', to: 'display#show', as: :channel
  get '/:channel_id/:date', to: 'display#show_by_date', as: :channel_date

  get 'display/index'
  get 'display/show'
  # resources :messages
  # resources :attachments
  # resources :users
  # resources :channels
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
